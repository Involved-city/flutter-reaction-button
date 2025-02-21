import 'package:flutter/material.dart';

import 'reactions_box_item.dart';
import 'reactions_position.dart';
import 'reaction.dart';
import 'extensions.dart';

class ReactionsBox extends StatefulWidget {
  final Offset buttonOffset;

  final Size buttonSize;

  final List<Reaction?> reactions;

  final Position position;

  final Color color;

  final double elevation;

  final double radius;

  final Duration duration;

  final Color? highlightColor;

  final Color? splashColor;

  final AlignmentGeometry alignment;

  final EdgeInsets boxPadding;

  final double boxItemsSpacing;

  final BorderRadiusGeometry borderRadius;

  final double positionRight;

  final double bottomPositionBy;


  const ReactionsBox({
    Key? key,
    required this.buttonOffset,
    required this.buttonSize,
    required this.reactions,
    required this.position,
    this.color = Colors.white,
    this.elevation = 5,
    this.radius = 50,
    this.duration = const Duration(milliseconds: 200),
    this.highlightColor,
    this.splashColor,
    this.alignment = Alignment.center,
    this.boxPadding = const EdgeInsets.all(0),
    this.boxItemsSpacing = 0,
    required this.borderRadius,
    this.positionRight = 0,
    required this.bottomPositionBy,
  }) : super(key: key);

  @override
  _ReactionsBoxState createState() => _ReactionsBoxState();
}

class _ReactionsBoxState extends State<ReactionsBox>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;

  late Animation<double> _scaleAnimation;
  double _scale = 0;

  Reaction? _selectedReaction;

  @override
  void initState() {
    super.initState();
    _scaleController =
        AnimationController(vsync: this, duration: widget.duration);

    final Tween<double> startTween = Tween(begin: 0, end: 1);
    _scaleAnimation = startTween.animate(_scaleController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.reverse)
          Navigator.of(context).pop(_selectedReaction);
      });

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: widget.alignment,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (_) => _scaleController.reverse(),
              onVerticalDragUpdate: (_) => _scaleController.reverse(),
              onHorizontalDragUpdate: (_) => _scaleController.reverse(),
            ),
          ),
          Positioned(
            top: _getPosition(context),
            right: widget.positionRight,
            child: Transform.scale(
              scale: _scale,
              child: Card(
                color: widget.color,
                elevation: widget.elevation,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: widget.borderRadius,
                ),
                child: Padding(
                  padding: widget.boxPadding,
                  child: Wrap(
                    spacing: widget.boxItemsSpacing,
                    children: widget.reactions
                        .map(
                          (reaction) => ReactionsBoxItem(
                            onReactionClick: (reaction) {
                              _selectedReaction = reaction;
                              _scaleController.reverse();
                            },
                            splashColor: widget.splashColor,
                            highlightColor: widget.highlightColor,
                            reaction: reaction,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  double _getPosition(BuildContext context) =>
      (_getTopPosition() - widget.buttonSize.height * 2 < 0)
          ? _getBottomPosition()
          : (_getBottomPosition() + widget.buttonSize.height * 2 >
                  context.screenSize.height)
              ? _getTopPosition()
              : widget.position == Position.TOP
                  ? _getTopPosition()
                  : _getBottomPosition();

  double _getTopPosition() =>
      widget.buttonOffset.dy - widget.buttonSize.height * widget.bottomPositionBy;

  double _getBottomPosition() =>
      widget.buttonOffset.dy + widget.buttonSize.height;
}
