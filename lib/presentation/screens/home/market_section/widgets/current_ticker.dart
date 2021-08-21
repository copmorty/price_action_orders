import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'input_symbol.dart';

class CurrentTicker extends StatefulWidget {
  final String baseAsset;
  final String quoteAsset;

  const CurrentTicker({
    Key? key,
    required this.baseAsset,
    required this.quoteAsset,
  }) : super(key: key);

  @override
  _CurrentTickerState createState() => _CurrentTickerState();
}

class _CurrentTickerState extends State<CurrentTicker> {
  final GlobalKey actionKey = LabeledGlobalKey('dropping');
  final parentOverlayKey = Key('parentOverlay');
  final childOverlayKey = Key('childOverlay');
  late Key overlayKey;
  bool isDropdownOpened = false;
  OverlayEntry? floatingDropdown;

  OverlayEntry _createFloatingDropdown() {
    RenderBox renderBox = actionKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 5.0,
          width: size.width * 2,
          height: size.height * 3,
          child: MouseRegion(
            onEnter: (_) => overlayKey = childOverlayKey,
            onExit: (_) => _destroyFloatingDropdown(childOverlayKey),
            child: Material(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: greyColor800,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Center(child: InputSymbol(minimize: true, callback: () => _destroyFloatingDropdown(childOverlayKey))),
              ),
            ),
          ),
        );
      },
    );
  }

  void _destroyFloatingDropdown(Key key) async {
    await Future.delayed(Duration(milliseconds: 100));

    if (key == overlayKey) {
      floatingDropdown!.remove();
      isDropdownOpened = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: actionKey,
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        overlayKey = parentOverlayKey;
        if (isDropdownOpened == false) {
          floatingDropdown = _createFloatingDropdown();
          Overlay.of(context)!.insert(floatingDropdown!);
          isDropdownOpened = true;
        }
      },
      onExit: (_) => _destroyFloatingDropdown(parentOverlayKey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.baseAsset + '/' + widget.quoteAsset,
            style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 5),
          Icon(Icons.arrow_drop_down, size: 15, color: whiteColorOp70),
        ],
      ),
    );
  }
}
