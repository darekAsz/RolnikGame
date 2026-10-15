# Generuje tlo ekranu wioski (bez budynkow) zgodne z ukladem _VillageLayout
# z lib/widgets/village_board.dart. Wspolrzedne "ref" (700x1100) mapuja sie
# liniowo na piksele renderu: obraz pokrywa ref x in [X0,X1], y in [Y0,Y1].
import bpy, bmesh, math, random
from mathutils import Vector, Matrix

OUT = globals().get("OUT_PATH", "C:/tmp/village_bg.png")
PX_PER_UNIT = globals().get("PX_PER_UNIT", 2)
X0, X1, Y0, Y1 = -80, 780, -260, 1360
U = 0.01
TILT = math.radians(35)
K = 1 / math.cos(TILT)
SEASON = globals().get("SEASON", "summer")  # spring | summer | autumn | winter
rng = random.Random(7)      # pozycje obiektow - identyczne we wszystkich porach roku
rng_t = random.Random(11)   # ksztalty szablonow

# ------------------------------------------------------------------ scena
SCN = "WioskaTlo"
if SCN in bpy.data.scenes:
    old = bpy.data.scenes[SCN]
    for o in list(old.objects):
        bpy.data.objects.remove(o, do_unlink=True)
    bpy.data.scenes.remove(old)
for coll in (bpy.data.meshes, bpy.data.materials, bpy.data.curves):
    for d in list(coll):
        if d.users == 0:
            coll.remove(d)
scn = bpy.data.scenes.new(SCN)
bpy.context.window.scene = scn
col = scn.collection

root = bpy.data.objects.new("MapRoot", None)
root.scale = (1, K, 1)
col.objects.link(root)


def M(x, y, z=0.0):
    return Vector((x * U, -y * U, z))


def link(obj):
    col.objects.link(obj)
    obj.parent = root
    return obj


# ------------------------------------------------------------------ materialy
def _bsdf(m):
    m.use_nodes = True
    nt = m.node_tree
    b = nt.nodes.get("Principled BSDF")
    b.inputs["Roughness"].default_value = 0.85
    if "Specular IOR Level" in b.inputs:
        b.inputs["Specular IOR Level"].default_value = 0.15
    return nt, b


def hexc(h, a=1.0):
    h = h.lstrip("#")
    c = [int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)]
    c = [x / 12.92 if x <= 0.04045 else ((x + 0.055) / 1.055) ** 2.4 for x in c]
    return (*c, a)


def mat_flat(name, color, rough=0.85):
    m = bpy.data.materials.new(name)
    nt, b = _bsdf(m)
    b.inputs["Base Color"].default_value = hexc(color)
    b.inputs["Roughness"].default_value = rough
    m.diffuse_color = hexc(color)
    return m


def mat_noise(name, c1, c2, scale=8.0, detail=3.0, c3=None, scale2=None):
    m = bpy.data.materials.new(name)
    nt, b = _bsdf(m)
    tc = nt.nodes.new("ShaderNodeTexCoord")
    nz = nt.nodes.new("ShaderNodeTexNoise")
    nz.inputs["Scale"].default_value = scale
    nz.inputs["Detail"].default_value = detail
    nt.links.new(tc.outputs["Object"], nz.inputs["Vector"])
    ramp = nt.nodes.new("ShaderNodeValToRGB")
    ramp.color_ramp.elements[0].position = 0.35
    ramp.color_ramp.elements[0].color = hexc(c1)
    ramp.color_ramp.elements[1].position = 0.65
    ramp.color_ramp.elements[1].color = hexc(c2)
    nt.links.new(nz.outputs["Fac"], ramp.inputs["Fac"])
    out = ramp.outputs["Color"]
    if c3 is not None:
        nz2 = nt.nodes.new("ShaderNodeTexNoise")
        nz2.inputs["Scale"].default_value = scale2 or scale / 6
        nz2.inputs["Detail"].default_value = 2.0
        nt.links.new(tc.outputs["Object"], nz2.inputs["Vector"])
        r2 = nt.nodes.new("ShaderNodeValToRGB")
        r2.color_ramp.elements[0].position = 0.42
        r2.color_ramp.elements[0].color = (1, 1, 1, 1)
        r2.color_ramp.elements[1].position = 0.62
        r2.color_ramp.elements[1].color = hexc(c3)
        nt.links.new(nz2.outputs["Fac"], r2.inputs["Fac"])
        mix = nt.nodes.new("ShaderNodeMix")
        mix.data_type = "RGBA"
        mix.blend_type = "MULTIPLY"
        mix.inputs[0].default_value = 1.0
        nt.links.new(out, mix.inputs[6])
        nt.links.new(r2.outputs["Color"], mix.inputs[7])
        out = mix.outputs[2]
    nt.links.new(out, b.inputs["Base Color"])
    m.diffuse_color = hexc(c1)
    return m


def mat_soft_disc(name, color, edge=0.7):
    """Kolor z miekko zanikajacym brzegiem (dla dysku o promieniu 1)."""
    m = bpy.data.materials.new(name)
    nt, b = _bsdf(m)
    b.inputs["Base Color"].default_value = hexc(color)
    tc = nt.nodes.new("ShaderNodeTexCoord")
    gr = nt.nodes.new("ShaderNodeTexGradient")
    gr.gradient_type = "SPHERICAL"
    nt.links.new(tc.outputs["Object"], gr.inputs["Vector"])
    ramp = nt.nodes.new("ShaderNodeValToRGB")
    ramp.color_ramp.elements[0].position = 0.0
    ramp.color_ramp.elements[0].color = (0, 0, 0, 1)
    ramp.color_ramp.elements[1].position = edge
    ramp.color_ramp.elements[1].color = (0.85, 0.85, 0.85, 1)
    nt.links.new(gr.outputs["Fac"], ramp.inputs["Fac"])
    nt.links.new(ramp.outputs["Color"], b.inputs["Alpha"])
    nz = nt.nodes.new("ShaderNodeTexNoise")
    nz.inputs["Scale"].default_value = 6
    nt.links.new(tc.outputs["Object"], nz.inputs["Vector"])
    r2 = nt.nodes.new("ShaderNodeValToRGB")
    r2.color_ramp.elements[0].color = hexc("#B89A64")
    r2.color_ramp.elements[1].color = hexc(color)
    nt.links.new(nz.outputs["Fac"], r2.inputs["Fac"])
    nt.links.new(r2.outputs["Color"], b.inputs["Base Color"])
    try:
        m.surface_render_method = "BLENDED"
    except Exception:
        m.blend_method = "BLEND"
    return m


def mat_water(name):
    m = bpy.data.materials.new(name)
    nt, b = _bsdf(m)
    b.inputs["Roughness"].default_value = 0.12
    if "Specular IOR Level" in b.inputs:
        b.inputs["Specular IOR Level"].default_value = 0.6
    tc = nt.nodes.new("ShaderNodeTexCoord")
    nz = nt.nodes.new("ShaderNodeTexNoise")
    nz.inputs["Scale"].default_value = 14
    nz.inputs["Detail"].default_value = 2
    nt.links.new(tc.outputs["Object"], nz.inputs["Vector"])
    ramp = nt.nodes.new("ShaderNodeValToRGB")
    ramp.color_ramp.elements[0].position = 0.4
    ramp.color_ramp.elements[0].color = hexc("#2F7FC8")
    ramp.color_ramp.elements[1].position = 0.7
    ramp.color_ramp.elements[1].color = hexc("#5DB3E8")
    nt.links.new(nz.outputs["Fac"], ramp.inputs["Fac"])
    nt.links.new(ramp.outputs["Color"], b.inputs["Base Color"])
    em = "Emission Color" if "Emission Color" in b.inputs else "Emission"
    nt.links.new(ramp.outputs["Color"], b.inputs[em])
    b.inputs["Emission Strength"].default_value = 0.25
    m.diffuse_color = hexc("#3A8DDE")
    return m


PAL = {
    "grass": ("#5E9E36", "#7DBE48", "#C9DDAF"),
    "path": ("#C9AE78", "#E2CFA0", "#E6DCC8"),
    "path_edge": ("#8B7348", "#A48A5A"),
    "clearing": "#D6BF8C",
    "bank": ("#6E6A3E", "#8A7D4C"),
    "leaf1": ("#3C8A2A", "#5BAA3A"),
    "leaf2": ("#4E9A30", "#79BF45"),
    "leaf3": ("#6E9E2E", "#9CC44A"),
    "pine": ("#2C6B32", "#3F8A3E"),
    "bush": ("#3F8E33", "#6CB244"),
    "soil": ("#6B4A2A", "#7E5832"),
    "wheat": ("#D9A93C", "#F0CB5C"),
    "reed": "#6E8E3A",
    "tuft": "#4E9532",
    "trail": ("#7E8A45", "#A0925E"),
    "flag": ("#7F7B72", "#A39D90"),
    "orchard_leaf": ("#4E9A30", "#6DB43E"),
    "fruit": "#D8342A",
    "petals": ["#E0453A", "#F6D43C", "#F4F1EA", "#9B6BD6", "#F28CB8"],
    "petal_base": None,  # None = zielona kepka (material krzaka)
    "sun": ((1.0, 0.96, 0.88), 4.2),
    "sky": (0.62, 0.74, 0.92),
    "wheat_h": 0.6,
    "crop_scale": 1.0,
}
PAL.update({
    "spring": {
        "grass": ("#68B23C", "#8FD258", "#D6EDB6"),
        "leaf1": ("#4FA634", "#74C046"),
        "leaf2": ("#5DB03A", "#8BD05A"),
        "leaf3": ("#68B53E", "#92D35C"),
        "bush": ("#4FA83A", "#80C955"),
        "wheat": ("#6FBE44", "#92D663"),
        "tuft": "#5BAA3A",
        "orchard_leaf": ("#5DAA3A", "#84C752"),
        "fruit": "#F48FB8",
        "wheat_h": 0.25,
        "crop_scale": 0.55,
        "sun": ((1.0, 0.97, 0.92), 4.3),
        "sky": (0.66, 0.78, 0.95),
    },
    "summer": {},
    "autumn": {
        "grass": ("#93A644", "#B5BC58", "#E8DCA8"),
        "leaf1": ("#D9622B", "#EE8A3A"),
        "leaf2": ("#B93A22", "#D85A34"),
        "leaf3": ("#E2A72C", "#F2C94C"),
        "bush": ("#A8532A", "#C97A3A"),
        "wheat": ("#C9A860", "#DCC07A"),
        "tuft": "#9A9545",
        "reed": "#9A8A4E",
        "petals": ["#D9622B", "#B93A22", "#E2A72C", "#8E5A2E", "#EE8A3A"],
        "petal_base": "#B86A30",
        "orchard_leaf": ("#9DAA3C", "#CDB548"),
        "wheat_h": 0.16,
        "sun": ((1.0, 0.86, 0.68), 3.9),
        "sky": (0.78, 0.72, 0.62),
    },
    "winter": {
        "grass": ("#CFDCEA", "#F4F8FC", "#B3C6DC"),
        "path": ("#9C8A72", "#B8A68C", "#E4E8EE"),
        "path_edge": ("#6F6A64", "#857F77"),
        "clearing": "#D9D4CC",
        "bank": ("#7E8A94", "#97A2AB"),
        "pine": ("#2E5C3A", "#F1F5FA"),
        "bush": ("#D8E2EC", "#FFFFFF"),
        "soil": ("#BFCAD6", "#D9E1EA"),
        "wheat": ("#E8EEF5", "#FFFFFF"),
        "reed": "#8B7A55",
        "trail": ("#B5ADA2", "#D2CCC3"),
        "flag": ("#B4B8BE", "#E4E8EC"),
        "wheat_h": 0.35,
        "sun": ((0.92, 0.96, 1.0), 3.6),
        "sky": (0.74, 0.82, 0.95),
    },
}[SEASON])
WINTER = SEASON == "winter"


def mat_ice(name):
    m = mat_noise(name, "#7FB6D8", "#BFE2F4", scale=10, detail=2)
    m.node_tree.nodes.get("Principled BSDF").inputs["Roughness"].default_value = 0.25
    return m


MAT = {
    "grass": mat_noise("Trawa", *PAL["grass"][:2], scale=60, detail=6, c3=PAL["grass"][2], scale2=1.6),
    "path": mat_noise("Droga", *PAL["path"][:2], scale=40, detail=5, c3=PAL["path"][2], scale2=6),
    "path_edge": mat_noise("DrogaBrzeg", *PAL["path_edge"], scale=30),
    "clearing": mat_soft_disc("Udeptana", PAL["clearing"]),
    "water": mat_ice("Lod") if WINTER else mat_water("Woda"),
    "bank": mat_noise("Brzeg", *PAL["bank"], scale=30),
    "bark": mat_flat("Kora", "#6B4423"),
    "leaf1": mat_noise("Liscie1", *PAL["leaf1"], scale=9),
    "leaf2": mat_noise("Liscie2", *PAL["leaf2"], scale=9),
    "leaf3": mat_noise("Liscie3", *PAL["leaf3"], scale=9),
    "pine": mat_noise("Swierk", *PAL["pine"], scale=9),
    "bush": mat_noise("Krzak", *PAL["bush"], scale=12),
    "rock": mat_noise("Kamien", "#8E9196", "#B9BCC0", scale=18),
    "wood": mat_noise("Drewno", "#9A6A35", "#B88447", scale=25),
    "wood_dark": mat_flat("DrewnoCiemne", "#5C3A1C"),
    "soil": mat_noise("Ziemia", *PAL["soil"], scale=40),
    "wheat": mat_noise("Pszenica", *PAL["wheat"], scale=30),
    "crop": mat_noise("Warzywa", "#4C9A34", "#7CC24A", scale=20),
    "pumpkin": mat_noise("Dynia", "#E07A1F", "#F29A35", scale=20),
    "hay": mat_noise("Siano", "#D8B04A", "#ECC965", scale=30),
    "snow": mat_noise("Snieg", "#E6EEF6", "#FFFFFF", scale=20),
    "reed": mat_flat("Trzcina", PAL["reed"]),
    "lily": mat_flat("Lilia", "#4F9A3A"),
    "tuft": mat_flat("Kepka", PAL["tuft"]),
    "trail": mat_noise("Sciezka", *PAL["trail"], scale=35),
    "flag": mat_noise("Plyty", *PAL["flag"], scale=60),
    "orchard_leaf": mat_noise("SadLiscie", *PAL["orchard_leaf"], scale=12),
    "fruit": mat_flat("Owoce", PAL["fruit"]),
    "blossom_pink": mat_flat("KwiatyRozowe", "#F48FB8"),
    "blossom_white": mat_flat("KwiatyBiale", "#FFF7FA"),
    "blossom_full": mat_noise("KoronaKwitnaca", "#EE93B8", "#F8C3D7", scale=12),
    "metal": mat_flat("Metal", "#55524E"),
}
MAT["petal_base"] = mat_flat("PodstawaKwiatow", PAL["petal_base"]) if PAL["petal_base"] else MAT["bush"]
for i, c in enumerate(PAL["petals"]):
    MAT[f"petal{i}"] = mat_flat(f"Platki{i}", c)

# ------------------------------------------------------------------ geometria
def cubic(p0, c1, c2, p1, n=24):
    out = []
    for i in range(n + 1):
        t = i / n
        a = (1 - t) ** 3
        b = 3 * (1 - t) ** 2 * t
        c = 3 * (1 - t) * t * t
        d = t ** 3
        out.append((a * p0[0] + b * c1[0] + c * c2[0] + d * p1[0],
                    a * p0[1] + b * c1[1] + c * c2[1] + d * p1[1]))
    return out


def poly_of(pts):
    out = []
    for i in range(0, len(pts) - 1, 3):
        seg = cubic(pts[i], pts[i + 1], pts[i + 2], pts[i + 3])
        out.extend(seg if not out else seg[1:])
    return out


def straight(a, b):
    return [a, (a[0] + (b[0] - a[0]) / 3, a[1] + (b[1] - a[1]) / 3),
            (a[0] + 2 * (b[0] - a[0]) / 3, a[1] + 2 * (b[1] - a[1]) / 3), b]


MAIN = [(362, -280), (385, -130), (300, 10), (350, 90),
        (440, 220), (260, 300), (350, 400),
        (440, 500), (250, 580), (320, 680),
        (380, 760), (280, 830), (300, 900),
        (316.7, 936.7), (333.3, 973.3), (350, 1010),
        (375, 1065), (325, 1250), (342, 1380)]
MAIN_R, BR_R = 15, 6
MAIN_POLY = poly_of(MAIN)


def nearest_on(poly, x, y):
    best = (1e18, None, None)
    for i in range(len(poly) - 1):
        (ax, ay), (bx, by) = poly[i], poly[i + 1]
        dx, dy = bx - ax, by - ay
        L2 = dx * dx + dy * dy or 1
        t = max(0, min(1, ((x - ax) * dx + (y - ay) * dy) / L2))
        px, py = ax + t * dx, ay + t * dy
        d = (x - px) ** 2 + (y - py) ** 2
        if d < best[0]:
            L = math.sqrt(L2)
            best = (d, (px, py), (dx / L, dy / L))
    return best[1], best[2]


def branch_pts(parent, parent_r, hint, end, bend=0.45, wiggle=0.0):
    """Sciezka odchodzaca lagodnym lukiem od drogi-rodzica (start dokladnie na niej)."""
    (sx, sy), (tx, ty) = nearest_on(parent, *hint)
    ex, ey = end
    if (ex - sx) * tx + (ey - sy) * ty < 0:
        tx, ty = -tx, -ty
    nx, ny = -ty, tx
    if (ex - sx) * nx + (ey - sy) * ny < 0:
        nx, ny = -nx, -ny
    L = math.hypot(ex - sx, ey - sy)
    dx, dy = tx * bend + nx * (1 - bend), ty * bend + ny * (1 - bend)
    dl = math.hypot(dx, dy)
    dx, dy = dx / dl, dy / dl
    s0 = (sx - nx * parent_r * 0.5, sy - ny * parent_r * 0.5)
    c1 = (sx + dx * L * 0.4, sy + dy * L * 0.4)
    ax, ay = ex - c1[0], ey - c1[1]
    al = math.hypot(ax, ay) or 1
    c2 = (ex - ax / al * L * 0.3, ey - ay / al * L * 0.3)
    # lekkie wygiecie w "S", zeby sciezka nie wygladala jak od linijki
    px, py = -(ey - sy) / L, (ex - sx) / L
    c1 = (c1[0] + px * wiggle * L * 0.5, c1[1] + py * wiggle * L * 0.5)
    c2 = (c2[0] - px * wiggle * L, c2[1] - py * wiggle * L)
    return [s0, c1, c2, (ex, ey)]


# (rodzic: "main" albo indeks wczesniejszej sciezki, punkt odejscia, cel)
BRANCH_DEFS = [
    ("main", (330, 440), (150, 500)),   # 0 sklep
    ("main", (378, 320), (570, 230)),   # 1 karczma
    ("main", (352, 130), (170, 215)),   # 2 kuznia
    ("main", (392, 165), (460, 170)),   # 3 spichlerz
    ("main", (375, 458), (440, 500)),   # 4 browar
    ("main", (300, 600), (140, 660)),   # 5 kaplica
    (5, (142, 662), (110, 830)),        # 6 szkola (dalej od kaplicy)
    ("main", (330, 690), (580, 700)),   # 7 rynek
    ("main", (300, 870), (580, 860)),   # 8 koszary
    ("main", (305, 915), (225, 915)),   # 9 magazyn
    ("main", (322, 940), (450, 915)),   # 10 kamieniarz
    ("main", (352, 240), (290, 225)),   # 11 dom
    ("main", (306, 622), (405, 635)),   # 12 piekarnia
    ("main", (325, 792), (245, 775)),   # 13 studnia
]
BRANCHES = []
BRANCH_POLYS = []
for bi, (parent, hint, end) in enumerate(BRANCH_DEFS):
    ppoly, pr = (MAIN_POLY, MAIN_R) if parent == "main" else (BRANCH_POLYS[parent], BR_R)
    long_ = math.hypot(end[0] - hint[0], end[1] - hint[1]) > 120
    pts = branch_pts(ppoly, pr, hint, end, wiggle=(0.13 if bi % 2 else -0.13) if long_ else 0.04)
    BRANCHES.append(pts)
    BRANCH_POLYS.append(poly_of(pts))
PATHS = [(MAIN_POLY, MAIN_R)] + [(bp, BR_R) for bp in BRANCH_POLYS]


def bezier_obj(name, pts, radius_units, mat, z):
    cu = bpy.data.curves.new(name, "CURVE")
    cu.dimensions = "3D"
    cu.resolution_u = 24
    cu.bevel_depth = radius_units * U
    cu.bevel_resolution = 6
    cu.use_fill_caps = True
    sp = cu.splines.new("BEZIER")
    anchors = list(range(0, len(pts), 3))
    sp.bezier_points.add(len(anchors) - 1)
    for k, i in enumerate(anchors):
        bp = sp.bezier_points[k]
        bp.handle_left_type = bp.handle_right_type = "FREE"
        co = Vector(M(*pts[i]))
        bp.co = co
        rh = Vector(M(*pts[i + 1])) if i + 1 < len(pts) else co + (co - Vector(M(*pts[i - 1])))
        lh = Vector(M(*pts[i - 1])) if i > 0 else co - (rh - co)
        bp.handle_left, bp.handle_right = lh, rh
    ob = bpy.data.objects.new(name, cu)
    cu.materials.append(mat)
    link(ob)
    ob.location.z = z
    ob.scale = (1, 1, 0.12)
    return ob


def mesh_obj(name, verts, faces, mat, smooth=False):
    me = bpy.data.meshes.new(name)
    me.from_pydata(verts, [], faces)
    me.update()
    if mat:
        me.materials.append(mat)
    if smooth:
        for p in me.polygons:
            p.use_smooth = True
    ob = bpy.data.objects.new(name, me)
    return link(ob)


def disc(name, cx, cy, rx, ry, mat, z=0.001, seg=40):
    verts = [(0, 0, 0)] + [(math.cos(a), math.sin(a), 0) for a in
                           [2 * math.pi * i / seg for i in range(seg)]]
    faces = [(0, i + 1, (i + 1) % seg + 1) for i in range(seg)]
    ob = mesh_obj(name, verts, faces, mat)
    ob.location = M(cx, cy, z)
    ob.scale = (rx * U, ry * U, 1)
    return ob


def rrect_pts(l, t, r, b, rad, d, n_arc=10, n_edge=24):
    l, t, r, b, rad = l - d, t - d, r + d, b + d, rad + d
    pts = []
    corners = [((r - rad, t + rad), -90, (l + rad, t), (r - rad, t)),
               ((r - rad, b - rad), 0, (r, t + rad), (r, b - rad)),
               ((l + rad, b - rad), 90, (r - rad, b), (l + rad, b)),
               ((l + rad, t + rad), 180, (l, b - rad), (l, t + rad))]
    for (cx, cy), a0, e0, e1 in corners:
        for i in range(n_edge):
            f = i / n_edge
            pts.append((e0[0] + (e1[0] - e0[0]) * f, e0[1] + (e1[1] - e0[1]) * f))
        for i in range(n_arc):
            a = math.radians(a0 + 90 * i / n_arc)
            pts.append((cx + rad * math.cos(a), cy + rad * math.sin(a)))
    return pts


def ring(name, l, t, r, b, rad, d0, d1, mat, z):
    inner = rrect_pts(l, t, r, b, rad, d0)
    outer = rrect_pts(l, t, r, b, rad, d1)
    n = len(inner)
    verts = [tuple(M(x, y, 0)) for x, y in inner] + [tuple(M(x, y, 0)) for x, y in outer]
    faces = [(i, (i + 1) % n, n + (i + 1) % n, n + i) for i in range(n)]
    ob = mesh_obj(name, verts, faces, mat)
    ob.location.z = z
    return ob


# ------------------------------------------------------------------ szablony
TEMPLATES = {}


def bm_part(bm, kind, mat_idx, mtx, jitter=0.0, **kw):
    if kind == "ico":
        ret = bmesh.ops.create_icosphere(bm, subdivisions=kw.get("sub", 2), radius=kw["r"], matrix=mtx)
    elif kind == "cone":
        ret = bmesh.ops.create_cone(bm, cap_ends=True, cap_tris=False, segments=kw.get("seg", 8),
                                    radius1=kw["r1"], radius2=kw["r2"], depth=kw["d"], matrix=mtx)
    elif kind == "cube":
        ret = bmesh.ops.create_cube(bm, size=1.0, matrix=mtx)
    verts = ret["verts"]
    if jitter:
        for v in verts:
            v.co += Vector((rng_t.uniform(-1, 1), rng_t.uniform(-1, 1), rng_t.uniform(-1, 1))) * jitter
    faces = {f for v in verts for f in v.link_faces}
    for f in faces:
        f.material_index = mat_idx
    return faces


def template(name, mats, build, smooth_idx=()):
    bm = bmesh.new()
    build(bm)
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    for m in mats:
        me.materials.append(m)
    for p in me.polygons:
        p.use_smooth = p.material_index in smooth_idx
    TEMPLATES[name] = me
    return me


def T(x, y, z):
    return Matrix.Translation((x, y, z))


def S(sx, sy, sz):
    return Matrix.Diagonal((sx, sy, sz, 1))


def build_tree(leaf_count, blossoms=0):
    """Drzewo lisciaste; blossoms > 0 dosypuje drobne kwiaty (material 2) na korone."""
    def f(bm):
        bm_part(bm, "cone", 0, T(0, 0, 0.12), seg=7, r1=0.035, r2=0.025, d=0.24)
        blobs = []
        for _ in range(leaf_count):
            r = rng_t.uniform(0.11, 0.15)
            c = Vector((rng_t.uniform(-0.08, 0.08), rng_t.uniform(-0.08, 0.08), 0.33 + rng_t.uniform(-0.04, 0.08)))
            bm_part(bm, "ico", 1, T(*c), jitter=0.012, r=r, sub=2)
            blobs.append((c, r))
        for _ in range(blossoms):
            c, r = rng_t.choice(blobs)
            a = rng_t.uniform(0, 2 * math.pi)
            e = rng_t.uniform(0.0, 1.2)
            v = Vector((math.cos(a) * math.cos(e), math.sin(a) * math.cos(e), math.sin(e))) * r * 0.97
            bm_part(bm, "ico", 2, T(*(c + v)), r=0.014, sub=1)
    return f


def build_bare_tree(bm):
    bm_part(bm, "cone", 0, T(0, 0, 0.17), seg=7, r1=0.035, r2=0.015, d=0.34)
    for k in range(rng_t.randint(4, 6)):
        a = rng_t.uniform(0, 2 * math.pi)
        z = rng_t.uniform(0.18, 0.3)
        m = T(0, 0, z) @ Matrix.Rotation(a, 4, "Z") @ Matrix.Rotation(rng_t.uniform(0.6, 0.9), 4, "X") @ T(0, 0, 0.08)
        bm_part(bm, "cone", 0, m, seg=5, r1=0.012, r2=0.002, d=0.17)
        bm_part(bm, "ico", 1, m @ T(0, 0, 0.07) @ S(1, 1, 0.45), r=0.02, sub=1)
    bm_part(bm, "ico", 1, T(0, 0, 0.34) @ S(1, 1, 0.5), r=0.03, sub=1)


def build_pumpkin(bm):
    bm_part(bm, "ico", 0, T(0, 0, 0.03) @ S(1, 1, 0.75), jitter=0.004, r=0.05, sub=2)
    bm_part(bm, "cone", 1, T(0, 0, 0.07), seg=5, r1=0.008, r2=0.005, d=0.025)


def build_flagstone(bm):
    bm_part(bm, "ico", 0, S(1, 0.8, 0.22), jitter=0.005, r=0.037, sub=1)


def build_fruit_tree(bm):
    bm_part(bm, "cone", 0, T(0, 0, 0.09), seg=7, r1=0.028, r2=0.022, d=0.18)
    for _ in range(3):
        bm_part(bm, "ico", 1, T(rng_t.uniform(-0.04, 0.04), rng_t.uniform(-0.04, 0.04), 0.25 + rng_t.uniform(-0.02, 0.03)),
                jitter=0.008, r=rng_t.uniform(0.085, 0.1), sub=2)
    for _ in range(11):
        a = rng_t.uniform(0, 2 * math.pi)
        e = rng_t.uniform(0.1, 1.1)
        v = Vector((math.cos(a) * math.cos(e), math.sin(a) * math.cos(e), math.sin(e))) * 0.115
        bm_part(bm, "ico", 2, T(v.x, v.y, 0.26 + v.z), r=0.014, sub=1)


def build_apple(bm):
    bm_part(bm, "ico", 0, T(0, 0, 0.008), r=0.012, sub=1)


def build_pine(bm):
    bm_part(bm, "cone", 0, T(0, 0, 0.07), seg=6, r1=0.03, r2=0.025, d=0.14)
    for i, (r, z) in enumerate([(0.17, 0.2), (0.13, 0.36), (0.09, 0.5)]):
        bm_part(bm, "cone", 1, T(0, 0, z), jitter=0.006, seg=9, r1=r, r2=0.0, d=0.24)


def build_bush(bm):
    for _ in range(3):
        bm_part(bm, "ico", 0, T(rng_t.uniform(-0.04, 0.04), rng_t.uniform(-0.04, 0.04), 0.05),
                jitter=0.008, r=rng_t.uniform(0.06, 0.08), sub=2)


def build_rock(bm):
    bm_part(bm, "ico", 0, S(1, 0.8, 0.55), jitter=0.012, r=0.05, sub=1)


def build_tuft(bm):
    for i in range(5):
        a = i / 5 * 2 * math.pi
        m = T(math.cos(a) * 0.01, math.sin(a) * 0.01, 0.02) @ Matrix.Rotation(rng_t.uniform(-0.4, 0.4), 4, "X")
        bm_part(bm, "cone", 0, m, seg=3, r1=0.006, r2=0.0, d=0.045)


def build_flowers(bm):
    bm_part(bm, "ico", 0, S(1, 1, 0.4) @ T(0, 0, 0.01), r=0.022, sub=1)
    for _ in range(6):
        bm_part(bm, "ico", 1, T(rng_t.uniform(-0.02, 0.02), rng_t.uniform(-0.02, 0.02), 0.022), r=0.007, sub=1)


def build_stump(bm):
    bm_part(bm, "cone", 0, T(0, 0, 0.025), seg=10, r1=0.035, r2=0.03, d=0.05)


def build_log_pile(bm):
    for row, n in enumerate([3, 2, 1]):
        for i in range(n):
            x = (i - (n - 1) / 2) * 0.042
            m = T(x, 0, 0.02 + row * 0.036) @ Matrix.Rotation(math.pi / 2, 4, "X")
            bm_part(bm, "cone", 0, m, seg=8, r1=0.02, r2=0.02, d=0.16)


def build_barrel(bm):
    bm_part(bm, "cone", 0, T(0, 0, 0.035), seg=10, r1=0.024, r2=0.024, d=0.07)
    for z in (0.015, 0.055):
        bm_part(bm, "cone", 1, T(0, 0, z), seg=10, r1=0.026, r2=0.026, d=0.008)


def build_crate(bm):
    bm_part(bm, "cube", 0, T(0, 0, 0.025) @ S(0.05, 0.05, 0.05))


def build_haystack(bm):
    bm_part(bm, "cone", 0, T(0, 0, 0.06), jitter=0.006, seg=12, r1=0.08, r2=0.0, d=0.14)
    bm_part(bm, "ico", 0, S(1, 1, 0.6) @ T(0, 0, 0.03), jitter=0.006, r=0.08, sub=2)


def build_bale(bm):
    bm_part(bm, "cone", 0, T(0, 0, 0.04) @ Matrix.Rotation(math.pi / 2, 4, "Y"), seg=14, r1=0.04, r2=0.04, d=0.06)


def build_reed(bm):
    for i in range(4):
        bm_part(bm, "cone", 0, T(rng_t.uniform(-0.012, 0.012), rng_t.uniform(-0.012, 0.012), 0.04),
                seg=3, r1=0.004, r2=0.0, d=0.08 + rng_t.uniform(0, 0.03))


tree_vars = []
for i, lm in enumerate(["leaf1", "leaf2", "leaf3"]):
    for j in range(2):
        nm = f"tpl_tree_{i}_{j}"
        if WINTER:
            template(nm, [MAT["bark"], MAT["snow"]], build_bare_tree, smooth_idx=(1,))
        else:
            # wiosna: zielone korony obsypane kwiatami (rozowymi albo bialymi)
            blossom = {"leaf1": "blossom_pink", "leaf3": "blossom_white"}.get(lm) if SEASON == "spring" else None
            if blossom:
                template(nm, [MAT["bark"], MAT[lm], MAT[blossom]], build_tree(rng_t.randint(3, 5), blossoms=34),
                         smooth_idx=(1, 2))
            else:
                template(nm, [MAT["bark"], MAT[lm]], build_tree(rng_t.randint(3, 5)), smooth_idx=(1,))
        tree_vars.append(nm)
pine_vars = []
for j in range(3):
    nm = f"tpl_pine_{j}"
    template(nm, [MAT["bark"], MAT["pine"]], build_pine)
    pine_vars.append(nm)
bush_vars = []
for j in range(3):
    nm = f"tpl_bush_{j}"
    template(nm, [MAT["bush"]], build_bush, smooth_idx=(0,))
    bush_vars.append(nm)
rock_vars = []
for j in range(4):
    nm = f"tpl_rock_{j}"
    template(nm, [MAT["rock"]], build_rock)
    rock_vars.append(nm)
template("tpl_tuft", [MAT["tuft"]], build_tuft)
flower_vars = []
for k in range(5):
    nm = f"tpl_flowers_{k}"
    template(nm, [MAT["petal_base"], MAT[f"petal{k}"]], build_flowers, smooth_idx=(0,))
    flower_vars.append(nm)
flag_vars = []
for j in range(3):
    nm = f"tpl_flag_{j}"
    template(nm, [MAT["flag"]], build_flagstone)
    flag_vars.append(nm)
orchard_vars = []
for j in range(3):
    nm = f"tpl_orchard_{j}"
    if WINTER:
        template(nm, [MAT["bark"], MAT["snow"]], build_bare_tree, smooth_idx=(1,))
    else:
        # wiosna: jedna odmiana w calosci w kwiatach (akcent), reszta zielona z kwiatami
        leaf = MAT["blossom_full"] if SEASON == "spring" and j == 0 else MAT["orchard_leaf"]
        dots = MAT["blossom_white"] if SEASON == "spring" and j == 0 else MAT["fruit"]
        template(nm, [MAT["bark"], leaf, dots], build_fruit_tree, smooth_idx=(1, 2))
    orchard_vars.append(nm)
template("tpl_apple", [MAT["fruit"]], build_apple, smooth_idx=(0,))
crop_vars = []
for j in range(3):
    nm = f"tpl_crop_{j}"
    if SEASON == "autumn":
        template(nm, [MAT["pumpkin"], MAT["crop"]], build_pumpkin, smooth_idx=(0,))
    else:
        template(nm, [MAT["crop"]], build_bush, smooth_idx=(0,))
    crop_vars.append(nm)
template("tpl_stump", [MAT["wood"]], build_stump)
template("tpl_logs", [MAT["wood"]], build_log_pile, smooth_idx=(0,))
template("tpl_barrel", [MAT["wood"], MAT["metal"]], build_barrel, smooth_idx=(0,))
template("tpl_crate", [MAT["wood"]], build_crate)
template("tpl_haystack", [MAT["hay"]], build_haystack, smooth_idx=(0,))
template("tpl_bale", [MAT["hay"]], build_bale, smooth_idx=(0,))
template("tpl_reed", [MAT["reed"]], build_reed)

# Obiekty, ktorych w danej porze roku nie ma - place() dalej zuzywa losowanie,
# zeby reszta sceny zostala na tych samych miejscach.
if WINTER:
    for k in flower_vars + crop_vars + ["tpl_tuft"]:
        TEMPLATES[k] = None
if SEASON == "spring":
    TEMPLATES["tpl_haystack"] = TEMPLATES["tpl_bale"] = None


def set_mat(ob, m):
    ob.material_slots[0].link = "OBJECT"
    ob.material_slots[0].material = m


def place(tpl, x, y, scale=1.0, rot=None, z=0.0):
    rot = rng.uniform(0, 2 * math.pi) if rot is None else rot
    if TEMPLATES[tpl] is None:
        return None
    ob = bpy.data.objects.new(tpl, TEMPLATES[tpl])
    link(ob)
    ob.location = M(x, y, z)
    ob.rotation_euler.z = rot
    ob.scale = (scale, scale, scale)
    return ob


# ------------------------------------------------------------------ strefy zakazane
# Musi sie zgadzac z _VillageLayout w lib/widgets/village_board.dart.
STD = [(150, 500), (570, 230), (580, 700), (225, 915), (170, 215), (440, 500), (140, 660), (110, 830), (580, 860)]
SMALL = [(290, 225), (460, 170), (405, 635), (490, 370), (245, 775), (450, 915)]
EXTRA = [(610, 400), (610, 560), (615, 760), (90, 355), (255, 330)]
RATUSZ = (350, 400)
PLOTS = [(x, y, 1.0) for x, y in STD + SMALL] + [(x, y, 0.75) for x, y in EXTRA] + [(*RATUSZ, 1.25)]
WALL = (70, 110, 630, 990)
GATES = [(350, 110), (350, 990)]


def dist_seg(px, py, a, b):
    ax, ay = a
    bx, by = b
    dx, dy = bx - ax, by - ay
    L = dx * dx + dy * dy
    t = 0 if L == 0 else max(0, min(1, ((px - ax) * dx + (py - ay) * dy) / L))
    return math.hypot(px - (ax + t * dx), py - (ay + t * dy))


def path_dist(x, y):
    best = 1e9
    for poly, r in PATHS:
        for i in range(len(poly) - 1):
            best = min(best, dist_seg(x, y, poly[i], poly[i + 1]) - r)
    return best


def in_building_zone(x, y, pad=0):
    for px, py, f in PLOTS:
        if abs(x - px) < 64 * f + pad and (py - 100 * f - pad) < y < (py + 42 * f + pad):
            return True
    for gx, gy in GATES:
        if abs(x - gx) < 70 + pad and abs(y - gy) < 45 + pad:
            return True
    return False


def wall_dist(x, y):
    l, t, r, b = WALL
    inside = l < x < r and t < y < b
    d = min(abs(x - l), abs(x - r), abs(y - t), abs(y - b)) if inside else 0
    if not inside:
        dx = max(l - x, 0, x - r)
        dy = max(t - y, 0, y - b)
        d = math.hypot(dx, dy)
    return d, inside


def free_inside(x, y, r):
    d, inside = wall_dist(x, y)
    return inside and d > 22 + r and not in_building_zone(x, y, r * 0.5) and path_dist(x, y) > r + 4


def free_outside(x, y, r):
    d, inside = wall_dist(x, y)
    return (not inside) and d > 40 + r and path_dist(x, y) > r + 6


# ------------------------------------------------------------------ ziemia, drogi, fosa
mesh_obj("Ziemia", [tuple(M(-200, -400)), tuple(M(900, -400)), tuple(M(900, 1500)), tuple(M(-200, 1500))],
         [(0, 1, 2, 3)], MAT["grass"])

bezier_obj("DrogaGlownaBrzeg", MAIN, MAIN_R + 3.5, MAT["path_edge"], 0.002)
bezier_obj("DrogaGlowna", MAIN, MAIN_R, MAT["path"], 0.004)


def main_dist(x, y):
    return min(dist_seg(x, y, MAIN_POLY[i], MAIN_POLY[i + 1]) for i in range(len(MAIN_POLY) - 1))


# boczne sciezki: wydeptany pasek ziemi + plaskie kamienie
for i, (pts, poly) in enumerate(zip(BRANCHES, BRANCH_POLYS)):
    bezier_obj(f"Sciezka{i}", pts, BR_R + 0.5, MAT["trail"], 0.0018)
    dist_acc, step, k = 0.0, 5.6, 0
    total = sum(math.hypot(poly[j + 1][0] - poly[j][0], poly[j + 1][1] - poly[j][1]) for j in range(len(poly) - 1))
    for j in range(len(poly) - 1):
        (ax, ay), (bx, by) = poly[j], poly[j + 1]
        L = math.hypot(bx - ax, by - ay)
        if L == 0:
            continue
        ux, uy = (bx - ax) / L, (by - ay) / L
        nx, ny = -uy, ux
        while dist_acc <= L:
            x, y = ax + ux * dist_acc, ay + uy * dist_acc
            k += 1
            offs = (-3.2, 3.2) if k % 2 else (0.0,)
            for o in offs:
                jx, jy = rng.uniform(-1.0, 1.0), rng.uniform(-0.8, 0.8)
                sx, sy = x + nx * (o + jx) + ux * jy, y + ny * (o + jx) + uy * jy
                tpl = rng.choice(flag_vars)
                sc = rng.uniform(0.8, 1.15)
                if main_dist(sx, sy) < MAIN_R + 3.5:
                    continue
                place(tpl, sx, sy, scale=sc, z=0.0075)
            dist_acc += step
        dist_acc -= L

# udeptane placyki pod budynkami
for i, (px, py, f) in enumerate(PLOTS):
    disc(f"Placyk{i}", px, py - 4 * f, 52 * f, 27 * f, MAT["clearing"], z=0.0042)

l, t, r, b = WALL
ring("FosaBrzeg", l, t, r, b, 36, 22 - 15, 22 + 15, MAT["bank"], 0.003)
ring("Fosa", l, t, r, b, 36, 22 - 10, 22 + 10, MAT["water"], 0.005)
# kamienie na brzegach fosy
for side_d in (22 - 15, 22 + 15):
    for (x, y) in rrect_pts(l, t, r, b, 36, side_d, n_arc=6, n_edge=30):
        if any(abs(x - gx) < 40 and abs(y - (gy - 22 if gy < 500 else gy + 22)) < 40 for gx, gy in GATES):
            continue
        if rng.random() < 0.55:
            place(rng.choice(rock_vars), x + rng.uniform(-3, 3), y + rng.uniform(-3, 3), scale=rng.uniform(0.4, 0.8))


def bridge(cx, cy):
    for i in range(-5, 6):
        pl = place("tpl_crate", cx, cy + i * 5.2, rot=0, z=0.008)
        pl.scale = (7.8, 0.9, 0.25)
        set_mat(pl, MAT["wood"])
    for sx in (-19, 19):
        for sy in (-27, -9, 9, 27):
            post = place("tpl_crate", cx + sx, cy + sy, rot=0)
            post.scale = (0.7, 0.7, 1.4)
            set_mat(post, MAT["wood_dark"])
        rail = place("tpl_crate", cx + sx, cy, rot=0, z=0.045)
        rail.scale = (0.5, 12.0, 0.4)
        set_mat(rail, MAT["wood"])


bridge(350, 110 - 22)
bridge(350, 990 + 22)

# ------------------------------------------------------------------ pola za murem
def field(x0, y0, x1, y1, kind):
    if kind == "orchard":
        rows = 0
        for cx in range(4):
            for cy in range(5):
                x = x0 + 32 + cx * 52
                y = y0 + 30 + cy * 50
                place(rng.choice(orchard_vars), x + rng.uniform(-3, 3), y + rng.uniform(-3, 3),
                      scale=rng.uniform(1.3, 1.45))
    else:
        disc_soil = mesh_obj(f"Pole_{kind}_{x0}_{y0}",
                             [tuple(M(x0, y0)), tuple(M(x1, y0)), tuple(M(x1, y1)), tuple(M(x0, y1))],
                             [(0, 1, 2, 3)], MAT["soil"])
        disc_soil.location.z = 0.003
        rows = int((x1 - x0) // 16)
    for i in range(rows):
        x = x0 + 10 + i * 16
        if kind == "wheat":
            row = place("tpl_crate", x, (y0 + y1) / 2, rot=0)
            row.scale = (1.9, (y1 - y0 - 14) / 5, PAL["wheat_h"])
            set_mat(row, MAT["wheat"])
        else:
            yy = y0 + 10
            while yy < y1 - 8:
                sc = rng.uniform(0.32, 0.42) * PAL["crop_scale"] * (1.5 if SEASON == "autumn" else 1.0)
                place(rng.choice(crop_vars), x + rng.uniform(-1, 1), yy, scale=sc)
                if WINTER:  # grzadki zasypane sniegiem
                    mound = place("tpl_crate", x, yy, rot=0)
                    mound.scale = (1.6, 2.2, 0.35)
                    set_mat(mound, MAT["snow"])
                yy += 13
    # plot
    posts = []
    for (ax, ay), (bx, by) in [((x0 - 8, y0 - 8), (x1 + 8, y0 - 8)), ((x1 + 8, y0 - 8), (x1 + 8, y1 + 8)),
                               ((x1 + 8, y1 + 8), (x0 - 8, y1 + 8)), ((x0 - 8, y1 + 8), (x0 - 8, y0 - 8))]:
        L = math.hypot(bx - ax, by - ay)
        n = max(1, int(L // 22))
        for i in range(n + 1):
            px, py = ax + (bx - ax) * i / n, ay + (by - ay) * i / n
            if path_dist(px, py) < 10:
                continue
            p = place("tpl_crate", px, py, rot=0)
            p.scale = (0.55, 0.55, 1.1)
            set_mat(p, MAT["wood_dark"])
        for i in range(n):
            mx, my = ax + (bx - ax) * (i + 0.5) / n, ay + (by - ay) * (i + 0.5) / n
            if path_dist(mx, my) < 16:
                continue
            ang = math.atan2(-(by - ay), bx - ax)
            for z in (0.018, 0.038):
                rl = place("tpl_crate", mx, my, rot=ang, z=z)
                rl.scale = (L / n / 5, 0.28, 0.28)
                set_mat(rl, MAT["wood"])


field(70, -220, 290, 30, "wheat")
field(420, -220, 640, 30, "crop")
field(70, 1060, 290, 1320, "orchard")
for (hx, hy) in [(120, -150), (210, -60), (250, -180)]:
    place("tpl_haystack", hx, hy, scale=rng.uniform(1.0, 1.3))
for (hx, hy) in [(470, 1080), (500, 1300)]:
    place("tpl_bale", hx, hy, scale=1.2)

# staw
disc("StawBrzeg", 530, 1200, 100, 70, MAT["bank"], z=0.003)
disc("Staw", 530, 1200, 88, 60, MAT["water"], z=0.005)
for i in range(40):
    a = rng.uniform(0, 2 * math.pi)
    place("tpl_reed", 530 + math.cos(a) * rng.uniform(84, 98), 1200 + math.sin(a) * rng.uniform(56, 68),
          scale=rng.uniform(0.9, 1.4))
for i in range(9):
    a = rng.uniform(0, 2 * math.pi)
    rr_ = rng.uniform(0.2, 0.8)
    if WINTER:
        continue
    lp = disc(f"Lilia{i}", 530 + math.cos(a) * 80 * rr_, 1200 + math.sin(a) * 50 * rr_, 6, 6, MAT["lily"], z=0.007, seg=10)

# ------------------------------------------------------------------ las i dekoracje
def scatter(n, rmin, test, fn, tries=20000):
    placed = []
    k = 0
    while len(placed) < n and k < tries:
        k += 1
        x, y = rng.uniform(X0 - 10, X1 + 10), rng.uniform(Y0 - 20, Y1 + 10)
        if not test(x, y, rmin):
            continue
        if any((x - a) ** 2 + (y - b) ** 2 < (rmin * 1.6) ** 2 for a, b in placed):
            continue
        placed.append((x, y))
        fn(x, y)
    return placed


def in_fields(x, y, pad=12):
    for x0, y0, x1, y1 in [(70, -220, 290, 30), (420, -220, 640, 30), (70, 1060, 290, 1320)]:
        if x0 - pad < x < x1 + pad and y0 - pad < y < y1 + pad:
            return True
    return (x - 530) ** 2 / 115 ** 2 + (y - 1200) ** 2 / 85 ** 2 < 1


def forest_test(x, y, r):
    return free_outside(x, y, r) and not in_fields(x, y, r)


def forest_tree(x, y):
    if rng.random() < 0.45:
        place(rng.choice(pine_vars), x, y, scale=rng.uniform(1.0, 1.5))
    else:
        place(rng.choice(tree_vars), x, y, scale=rng.uniform(1.0, 1.45))


scatter(420, 17, forest_test, forest_tree, tries=60000)
scatter(90, 9, forest_test, lambda x, y: place(rng.choice(bush_vars), x, y, scale=rng.uniform(0.8, 1.3)))
scatter(25, 5, forest_test, lambda x, y: place("tpl_stump", x, y, scale=rng.uniform(0.8, 1.3)))
scatter(140, 3, lambda x, y, r: forest_test(x, y, r) or (free_outside(x, y, r) and not in_fields(x, y, 0)),
        lambda x, y: place(rng.choice(flower_vars), x, y, scale=rng.uniform(0.8, 1.3)))

# wewnatrz muru
scatter(14, 20, free_inside, lambda x, y: place(rng.choice(tree_vars), x, y, scale=rng.uniform(0.9, 1.2)))
scatter(55, 9, free_inside, lambda x, y: place(rng.choice(bush_vars), x, y, scale=rng.uniform(0.7, 1.2)))
scatter(220, 3, free_inside, lambda x, y: place(rng.choice(flower_vars), x, y, scale=rng.uniform(0.8, 1.4)))
scatter(500, 2, lambda x, y, r: free_inside(x, y, r) or free_outside(x, y, r),
        lambda x, y: place("tpl_tuft", x, y, scale=rng.uniform(0.9, 1.6)))
scatter(35, 4, free_inside, lambda x, y: place(rng.choice(rock_vars), x, y, scale=rng.uniform(0.5, 1.0)))
for (x, y) in scatter(5, 14, free_inside, lambda x, y: None):
    place("tpl_logs", x, y, scale=1.0)
for (x, y) in scatter(4, 10, free_inside, lambda x, y: None):
    for j in range(rng.randint(2, 3)):
        place(rng.choice(["tpl_barrel", "tpl_crate"]), x + rng.uniform(-7, 7), y + rng.uniform(-5, 5), scale=1.0)

# kamyki przy krawedziach drogi glownej
for poly, r in PATHS[:1]:
    for i in range(0, len(poly) - 1, 2):
        (ax, ay), (bx, by) = poly[i], poly[i + 1]
        L = math.hypot(bx - ax, by - ay) or 1
        nx, ny = -(by - ay) / L, (bx - ax) / L
        for sgn in (-1, 1):
            if rng.random() < 0.22:
                x, y = ax + nx * sgn * (r + 5), ay + ny * sgn * (r + 5)
                if not in_building_zone(x, y):
                    place(rng.choice(rock_vars), x, y, scale=rng.uniform(0.3, 0.6))

# dodatki sezonowe (na koncu, zeby nie przesuwac reszty sceny)
if SEASON == "spring":
    scatter(260, 3, free_inside, lambda x, y: place(rng.choice(flower_vars), x, y, scale=rng.uniform(0.9, 1.5)))
    scatter(160, 3, lambda x, y, r: free_outside(x, y, r) and not in_fields(x, y, 0),
            lambda x, y: place(rng.choice(flower_vars), x, y, scale=rng.uniform(0.9, 1.5)))
elif SEASON == "summer":
    for (cx, cy) in [(120, 1300), (132, 1306)]:
        place("tpl_crate", cx, cy, rot=0.2)
elif SEASON == "autumn":
    for (cx, cy) in [(118, 1300), (131, 1305), (124, 1292), (250, 1140)]:
        place("tpl_crate", cx, cy, rot=0.3)
    for _ in range(70):
        place("tpl_apple", rng.uniform(80, 280), rng.uniform(1070, 1310))
    scatter(320, 3, lambda x, y, r: free_inside(x, y, r) or (free_outside(x, y, r) and not in_fields(x, y, 0)),
            lambda x, y: place(rng.choice(flower_vars), x, y, scale=rng.uniform(1.0, 1.8)))

# ------------------------------------------------------------------ swiatlo, kamera, render
sun_d = bpy.data.lights.new("Slonce", "SUN")
sun_d.energy = PAL["sun"][1]
sun_d.angle = math.radians(6)
sun_d.color = PAL["sun"][0]
sun = bpy.data.objects.new("Slonce", sun_d)
col.objects.link(sun)
sun.rotation_euler = Vector((0.55, -0.45, -0.75)).to_track_quat("-Z", "Y").to_euler()

world = bpy.data.worlds.new("NieboWioska")
world.use_nodes = True
bg = world.node_tree.nodes.get("Background")
bg.inputs["Color"].default_value = (*PAL["sky"], 1)
bg.inputs["Strength"].default_value = 1.1
scn.world = world

cam_d = bpy.data.cameras.new("Kamera")
cam_d.type = "ORTHO"
cam_d.ortho_scale = (Y1 - Y0) * U
cam_d.sensor_fit = "VERTICAL"
cam_d.clip_end = 200
cam = bpy.data.objects.new("Kamera", cam_d)
col.objects.link(cam)
cam.rotation_euler = (TILT, 0, 0)
cx, cy = (X0 + X1) / 2, (Y0 + Y1) / 2
target = Vector((cx * U, -cy * U * K, 0))
direction = Vector((0, math.sin(TILT), -math.cos(TILT)))
cam.location = target - direction * 50
scn.camera = cam

rd = scn.render
rd.engine = "BLENDER_EEVEE"
rd.resolution_x = int((X1 - X0) * PX_PER_UNIT)
rd.resolution_y = int((Y1 - Y0) * PX_PER_UNIT)
rd.resolution_percentage = 100
rd.film_transparent = False
rd.image_settings.file_format = "PNG"
rd.filepath = OUT
try:
    scn.eevee.taa_render_samples = 32
    scn.eevee.use_shadows = True
except Exception:
    pass
scn.view_settings.view_transform = "Standard"
scn.view_settings.look = "None"
scn.view_settings.exposure = 0.0

result = {"objects": len(scn.objects), "res": [rd.resolution_x, rd.resolution_y]}
