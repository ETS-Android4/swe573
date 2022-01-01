import 'package:flutter/material.dart';
import 'package:funxchange/framework/di.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:funxchange/models/message.dart';
import 'dart:ui' as ui;

class MessageTile extends StatelessWidget {
  final Message message;

  const MessageTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageIsMine =
        message.senderId == DIContainer.activeSingleton.userRepo.getCurrentUserId();
    return MessageBubble(
        message: message,
        child: Column(
          crossAxisAlignment:
              messageIsMine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(message.text),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: messageIsMine
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Text(
                  message.senderUserName + " - ",
                  style: const TextStyle(fontSize: 11),
                ),
                Text(
                  timeago.format(message.created, locale: 'en_short'),
                  style: const TextStyle(fontSize: 11),
                )
              ],
            )
          ],
        ));
  }
}

@immutable
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  final Message message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final messageIsMine =
        message.senderId == DIContainer.activeSingleton.userRepo.getCurrentUserId();
    final messageAlignment =
        messageIsMine ? Alignment.topLeft : Alignment.topRight;

    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.8,
      child: Align(
        alignment: messageAlignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: BubbleBackground(
              colors: [
                messageIsMine
                    ? const Color(0xFF6C7689)
                    : const Color(0xFF19B7FF),
                messageIsMine
                    ? const Color(0xFF3A364B)
                    : const Color(0xFF491CCB),
              ],
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class BubbleBackground extends StatelessWidget {
  const BubbleBackground({
    Key? key,
    required this.colors,
    this.child,
  }) : super(key: key);

  final List<Color> colors;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        scrollable: Scrollable.of(context)!,
        bubbleContext: context,
        colors: colors,
      ),
      child: child,
    );
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({
    required ScrollableState scrollable,
    required BuildContext bubbleContext,
    required List<Color> colors,
  })  : _scrollable = scrollable,
        _bubbleContext = bubbleContext,
        _colors = colors,
        super(repaint: scrollable.position);

  final ScrollableState _scrollable;
  final BuildContext _bubbleContext;
  final List<Color> _colors;

  @override
  void paint(Canvas canvas, Size size) {
    final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;
    final scrollableRect = Offset.zero & scrollableBox.size;
    final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;

    final origin =
        bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }
}

enum MessageOwner { myself, other }
