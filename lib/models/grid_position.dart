class GridPosition {
  final int row;
  final int col;

  const GridPosition(this.row, this.col);

  bool isAdjacentTo(GridPosition other) {
    if (this == other) return false;
    return (row - other.row).abs() <= 1 && (col - other.col).abs() <= 1;
  }

  @override
  bool operator ==(Object other) =>
      other is GridPosition && row == other.row && col == other.col;

  @override
  int get hashCode => Object.hash(row, col);
}
