import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wonderlist/sample/models/list_item_model.dart';

class Loga {
  static var logger = Logger(
    printer: PrettyPrinter(),
  );
}

class WonderList extends StatelessWidget {
  const WonderList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App'),
        ),
        body: Builder(builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: const MyList(),
          );
        }),
      ),
    );
  }
}

class MyList extends StatefulWidget {
  const MyList({Key? key}) : super(key: key);

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> with TickerProviderStateMixin {
  final animationControllers = <int, AnimationController>{};
  final scaleAnimations = <int, Animation<double>>{};

  @override
  void dispose() {
    animationControllers.clear();
    scaleAnimations.clear();
    super.dispose();
  }

  final nestedItemsMap = <int, ListItemModel>{};

  List<ListItemModel> items = [];

  @override
  void initState() {
    super.initState();

    const item1 = ListItemModel(
        name: 'Item 1', id: 1, childrenIds: [2, 3, 4, 5, 6, 7, 8]);
    const item2 = ListItemModel(name: 'Item 1 - 1', id: 2, targetId: 1);
    const item3 = ListItemModel(name: 'Item 1 - 2', id: 3, targetId: 1);
    const item4 = ListItemModel(name: 'Item 1 - 3', id: 4, targetId: 1);
    const item5 = ListItemModel(name: 'Item 1 - 4', id: 5, targetId: 1);
    const item6 = ListItemModel(name: 'Item 1 - 5', id: 6, targetId: 1);
    const item7 = ListItemModel(name: 'Item 1 - 6', id: 7, targetId: 1);
    const item8 = ListItemModel(
      name: 'Item 1 paging indicator',
      id: 8,
      targetId: 1,
      isPagingIndicator: true,
    );

    const item9 =
        ListItemModel(name: 'Item 2', id: 9, childrenIds: [10, 11, 12]);
    const item10 = ListItemModel(name: 'Item 2 - 1', id: 10, targetId: 9);
    const item11 = ListItemModel(name: 'Item 2 - 2', id: 11, targetId: 9);
    const item12 = ListItemModel(
      name: 'Item 2 paging indicator',
      id: 12,
      targetId: 9,
      isPagingIndicator: true,
    );

    const item13 =
        ListItemModel(name: 'Item 3', id: 13, childrenIds: [14, 15, 16, 17]);
    const item14 = ListItemModel(name: 'Item 3 - 1', id: 14, targetId: 13);
    const item15 = ListItemModel(name: 'Item 3 - 2', id: 15, targetId: 13);
    const item16 = ListItemModel(name: 'Item 3 - 3', id: 16, targetId: 13);
    const item17 = ListItemModel(
      name: 'Item 3 paging indicator',
      id: 17,
      targetId: 13,
      isPagingIndicator: true,
    );

    nestedItemsMap.putIfAbsent(item1.id, () => item1);
    nestedItemsMap.putIfAbsent(item2.id, () => item2);
    nestedItemsMap.putIfAbsent(item3.id, () => item3);
    nestedItemsMap.putIfAbsent(item4.id, () => item4);
    nestedItemsMap.putIfAbsent(item5.id, () => item5);
    nestedItemsMap.putIfAbsent(item6.id, () => item6);
    nestedItemsMap.putIfAbsent(item7.id, () => item7);
    nestedItemsMap.putIfAbsent(item8.id, () => item8);
    nestedItemsMap.putIfAbsent(item9.id, () => item9);
    nestedItemsMap.putIfAbsent(item10.id, () => item10);
    nestedItemsMap.putIfAbsent(item11.id, () => item11);
    nestedItemsMap.putIfAbsent(item12.id, () => item12);
    nestedItemsMap.putIfAbsent(item13.id, () => item13);
    nestedItemsMap.putIfAbsent(item14.id, () => item14);
    nestedItemsMap.putIfAbsent(item15.id, () => item15);
    nestedItemsMap.putIfAbsent(item16.id, () => item16);
    nestedItemsMap.putIfAbsent(item17.id, () => item17);

    items = nestedItemsMap.values.toList();

    for (var item in items) {
      final AnimationController animController = AnimationController(
        duration: kThemeAnimationDuration,
        value: 1,
        vsync: this,
      );

      final Animation<double> animation = CurvedAnimation(
        parent: animController,
        curve: Curves.fastOutSlowIn,
      );

      animationControllers[item.id] = animController;
      scaleAnimations[item.id] = animation;
    }
  }

  void collapse(List<int> ids) {
    for (var id in ids) {
      // TODO animation toglood duushaar ni collapsed bolgoh
      nestedItemsMap.update(
        id,
        (ListItemModel value) {
          final futures = <Future<void>>[];

          var itemIsCollapsed = value.isCollapsed;
          if (itemIsCollapsed) {
            animationControllers[id]!.forward();
          } else {
            animationControllers[id]!.reverse();
          }

          return value.copyWith(isCollapsed: !itemIsCollapsed);
        },
      );
    }

    items = nestedItemsMap.values.toList();
    setState(() {});
  }

  void add(int key, ListItemModel item) {
    nestedItemsMap.update(
      key,
      (value) => item, // key exist bol value -g update hine
      ifAbsent: () => item, // key exist bish bol {key, absentVal} -g nemne
    );
  }

  Map<int, ListItemModel> toMap(ListItemModel item) {
    final map = <int, ListItemModel>{};
    map[item.id] = item;
    return map;
  }

  int findParentIndex(int insertedIndex) {
    for (var i = insertedIndex - 1; 0 <= i; i--) {
      var item = items[i];
      if (item.targetId == null) {
        return i;
      }
    }

    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        ListItemModel item = items[index];
        var itemKey = ValueKey('item_key_${item.name}');

        return VisibilityDetector(
          key: itemKey,
          onVisibilityChanged: (visibilityInfo) {
            // print(visibilityInfo);
            var visiblePercentage =
                (visibilityInfo.visibleFraction * 100) / 100;
            bool isVisible = visiblePercentage == 1;
            bool isLoader = item.isPagingIndicator;
            if (isLoader && isVisible && !item.isLoading) {
              print(
                  'isVisible $isVisible item name ${item.name} targetId ${item.targetId}');
              // TODO tuhain hesgiin next page -iig duudna
              var tempItems = [...items];
              tempItems[index] = item.copyWith(isLoading: true);
              items = tempItems;
              setState(() {});

              Future.delayed(const Duration(seconds: 2), () {
                var tempItems = [...items];
                tempItems[index] = item.copyWith(isLoading: false);
                items = tempItems;
                setState(() {});
              });
            }
          },
          child: SizeTransition(
            sizeFactor: scaleAnimations[item.id]!,
            axis: Axis.vertical,
            child: ListItemWidget(
              key: itemKey,
              index: index,
              item: item,
              onParentClicked: (List<int> childrenIds) {
                collapse(childrenIds);
              },
            ),
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        handleReorder(oldIndex, newIndex);
      },
      buildDefaultDragHandles: false,
    );
  }

  void handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final ListItemModel item = items.removeAt(oldIndex);
      // remove child id from old parent
      int oldParentId = item.targetId!;
      int oldParentIndex = items.indexWhere((e) => e.id == oldParentId);
      var oldParentItem = items[oldParentIndex];
      final oldParentChildrenIds = [...oldParentItem.childrenIds];
      oldParentChildrenIds.remove(item.id);
      items[oldParentIndex] =
          oldParentItem.copyWith(childrenIds: oldParentChildrenIds);

      // find new parent
      int parentIndex = findParentIndex(newIndex);
      var parentItem = items[parentIndex];

      items.insert(newIndex, item.copyWith(targetId: parentItem.id));
      // update parent children ids
      items[parentIndex] = parentItem
          .copyWith(childrenIds: [...parentItem.childrenIds, item.id]);

      // update map
      nestedItemsMap.clear();
      for (var item in items) {
        add(item.id, item);
      }
      items = nestedItemsMap.values.toList();
      setState(() {});
    });
  }
}

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({
    Key? key,
    required this.index,
    required this.item,
    required this.onParentClicked,
  }) : super(key: key);

  final int index;
  final ListItemModel item;
  final Function(List<int>) onParentClicked;

  @override
  Widget build(BuildContext context) {
    bool isDraggable = item.targetId == null ? false : true;

    return Card(
      key: ValueKey('Item ${item.name}'),
      color: item.isPagingIndicator
          ? Colors.white
          : isDraggable
              ? Colors.green.shade100
              : Colors.pink.shade100,
      child: ListTile(
        onTap: () {
          if (item.targetId == null) {
            onParentClicked(item.childrenIds);
          }
        },
        leading: !item.isPagingIndicator && isDraggable
            ? ReorderableDragStartListener(
                index: index,
                enabled: isDraggable,
                child: const MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(Icons.drag_handle),
                ),
              )
            : null,
        title: item.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Text(
                item.isPagingIndicator
                    ? 'Paging Indicator'
                    : 'ID: ${item.id} Name: ${item.name} childrenIds ${item.childrenIds}',
                style: TextStyle(
                  fontWeight: item.childrenIds.isEmpty
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),
        // tileColor: oddItemColor,
      ),
    );
  }
}
