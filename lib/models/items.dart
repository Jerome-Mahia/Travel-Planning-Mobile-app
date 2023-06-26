class Item {
  final String image;
  final String title;
  bool isChosen;

  Item(this.image, this.title, this.isChosen);
}

final _single = Item('assets/images/single_svg.svg', 'single', false);
final _group = Item('assets/images/group_svg.svg', 'group', false);

List<Item> dataList = [
  _single,
  _group,
];