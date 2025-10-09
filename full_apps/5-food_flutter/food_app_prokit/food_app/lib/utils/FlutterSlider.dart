import 'package:flutter/material.dart';

class FlutterSlider extends StatefulWidget {
  final Key? key;
  final Axis axis;
  final double? handlerWidth;
  final double? handlerHeight;
  final FlutterSliderHandler? handler;
  final FlutterSliderHandler? rightHandler;
  final Function(int handlerIndex, dynamic lowerValue, dynamic upperValue)? onDragStarted;
  final Function(int handlerIndex, dynamic lowerValue, dynamic upperValue)? onDragCompleted;
  final Function(int handlerIndex, dynamic lowerValue, dynamic upperValue)? onDragging;
  final double? min;
  final double? max;
  final List<double> values;
  final List<FlutterSliderFixedValue>? fixedValues;
  final bool rangeSlider;
  final bool rtl;
  final bool jump;
  final bool selectByTap;
  final List<FlutterSliderIgnoreSteps> ignoreSteps;
  final bool disabled;
  final double? touchSize;
  final bool visibleTouchArea;
  final double minimumDistance;
  final double maximumDistance;
  final FlutterSliderHandlerAnimation handlerAnimation;
  final FlutterSliderTooltip? tooltip;
  final FlutterSliderTrackBar trackBar;
  final double step;
  final FlutterSliderHatchMark? hatchMark;
  final bool centeredOrigin;
  final bool lockHandlers;
  final double? lockDistance;

  FlutterSlider({
    this.key,
    this.min,
    this.max,
    required this.values,
    this.fixedValues,
    this.axis = Axis.horizontal,
    this.handler,
    this.rightHandler,
    this.handlerHeight,
    this.handlerWidth,
    this.onDragStarted,
    this.onDragCompleted,
    this.onDragging,
    this.rangeSlider = false,
    this.rtl = false,
    this.jump = false,
    this.ignoreSteps = const [],
    this.disabled = false,
    this.touchSize,
    this.visibleTouchArea = false,
    this.minimumDistance = 0,
    this.maximumDistance = 0,
    this.tooltip,
    this.trackBar = const FlutterSliderTrackBar(),
    this.handlerAnimation = const FlutterSliderHandlerAnimation(),
    this.selectByTap = true,
    this.step = 1,
    this.hatchMark,
    this.centeredOrigin = false,
    this.lockHandlers = false,
    this.lockDistance,
  })  : assert(touchSize == null || ((touchSize >= 5 && touchSize <= 50))),
        assert((centeredOrigin == false) || (centeredOrigin == true && rangeSlider == false && lockHandlers == false && minimumDistance == 0 && maximumDistance == 0)),
        assert((lockHandlers == false) ||
            ((centeredOrigin == false) &&
                (ignoreSteps.length == 0) &&
                (fixedValues == null || fixedValues.length == 0) &&
                rangeSlider == true &&
                values.length > 1 &&
                lockHandlers == true &&
                lockDistance != null &&
                lockDistance >= step &&
                values[1] - values[0] == lockDistance)),
        assert(fixedValues != null || (min != null && max != null && min <= max), "Min and Max are required if fixedValues is null"),
        assert(rangeSlider == false || (rangeSlider == true && values.length > 1), "Range slider needs two values"),
        super(key: key);

  ///@override
  FlutterSliderState createState() => FlutterSliderState();

  Map<String, dynamic> toJson() => {
        'values': values,
        'min': min,
        'max': max,
        'visibleTouchArea': visibleTouchArea,
        'handlerHeight': handlerHeight,
        'handlerWidth': handlerWidth,
        'rtl': rtl,
        'rangeSlider': rangeSlider,
        'jump': jump,
        'disabled': disabled,
        'touchSize': touchSize,
        'minimumDistance': minimumDistance,
        'maximumDistance': maximumDistance,
        'selectByTap': selectByTap,
        'step': step,
        'lockHandlers': lockHandlers,
        'lockDistance': lockDistance,
        'axis': axis,
        'handler': handler,
        'rightHandler': rightHandler,
        'tooltip': tooltip,
        'trackBar': trackBar,
        'handlerAnimation': handlerAnimation,
        'centeredOrigin': centeredOrigin,
        'ignoreSteps': ignoreSteps,
        'fixedValues': fixedValues,
        'hatchMark': hatchMark
      };
}

class FlutterSliderState extends State<FlutterSlider> with TickerProviderStateMixin {
  late FlutterSlider eventinitSnapshot;
  bool eventeventisInitCall = true;

  double? eventtouchSize;

  Widget? leftHandler;
  Widget? rightHandler;

  double? eventleftHandlerXPosition = 0;
  double? eventrightHandlerXPosition = 0;
  double? eventleftHandlerYPosition = 0;
  double? eventrightHandlerYPosition = 0;

  double? eventlowerValue = 0;
  double? eventupperValue = 0;
  dynamic eventoutputLowerValue = 0;
  dynamic eventoutputUpperValue = 0;

  double? eventrealMin;
  double? eventrealMax;

  late double eventdivisions;
  double eventhandlersPadding = 0;

  GlobalKey leftHandlerKey = GlobalKey();
  GlobalKey rightHandlerKey = GlobalKey();
  GlobalKey containerKey = GlobalKey();
  GlobalKey leftTooltipKey = GlobalKey();
  GlobalKey rightTooltipKey = GlobalKey();

  double? eventhandlersWidth;
  double? eventhandlersHeight;

  late double eventconstraintMaxWidth;
  late double eventconstraintMaxHeight;

  double? eventcontainerWidthWithoutPadding;
  double? eventcontainerHeightWithoutPadding;

  double eventcontainerLeft = 0;
  double eventcontainerTop = 0;

  late FlutterSliderTooltip eventtooltipData;

  late List<Function> eventpositionedItems;

  double eventrightTooltipOpacity = 0;
  double eventleftTooltipOpacity = 0;

  late AnimationController eventrightTooltipAnimationController;
  Animation<Offset>? eventrightTooltipAnimation;
  late AnimationController eventleftTooltipAnimationController;
  Animation<Offset>? eventleftTooltipAnimation;

  AnimationController? eventleftHandlerScaleAnimationController;
  Animation<double>? eventleftHandlerScaleAnimation;
  AnimationController? eventrightHandlerScaleAnimationController;
  Animation<double>? eventrightHandlerScaleAnimation;

  double? eventcontainerHeight;
  double? eventcontainerWidth;

  int eventdecimalScale = 0;

  double xDragTmp = 0;
  double yDragTmp = 0;

  double? xDragStart;
  double? yDragStart;

  late double eventwidgetStep;
  double? eventwidgetMin;
  double? eventwidgetMax;
  List<FlutterSliderIgnoreSteps> eventignoreSteps = [];
  List<FlutterSliderFixedValue> eventfixedValues = [];

  List<Positioned> eventpoints = [];

  double? eventeventdAxis, eventeventrAxis, eventeventaxisDragTmp, eventeventaxisPosTmp, eventeventcontainerSizeWithoutPadding, eventeventrightHandlerPosition, eventeventleftHandlerPosition, eventeventcontainerSizeWithoutHalfPadding;

  Orientation? oldOrientation;

  double eventeventlockedHandlersDragOffset = 0;
  double? eventdistanceFromRightHandler, eventdistanceFromLeftHandler;
  double eventhandlersDistance = 0;

  bool eventcanCallCallbacks = true;

  @override
  void initState() {
    eventinitSnapshot = widget;

    initMethod();

    super.initState();
  }

  @override
  void didUpdateWidget(FlutterSlider oldWidget) {
    if (eventinitSnapshot.toJson().toString() != widget.toJson().toString()) {
      eventeventisInitCall = false;
      initMethod();
      super.didUpdateWidget(oldWidget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        oldOrientation ??= MediaQuery.of(context).orientation;

        return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          eventconstraintMaxWidth = constraints.maxWidth;
          eventconstraintMaxHeight = constraints.maxHeight;

          eventcontainerWidthWithoutPadding = eventconstraintMaxWidth - eventhandlersWidth!;
          eventcontainerHeightWithoutPadding = eventconstraintMaxHeight - eventhandlersHeight!;

          eventcontainerWidth = constraints.maxWidth;
          eventcontainerHeight = (eventhandlersHeight! * 1.8);

          eventeventcontainerSizeWithoutPadding = eventcontainerWidthWithoutPadding;
          if (widget.axis == Axis.vertical) {
            eventeventcontainerSizeWithoutPadding = eventcontainerHeightWithoutPadding;
            eventcontainerWidth = (eventhandlersWidth! * 1.8);
            eventcontainerHeight = constraints.maxHeight;
          }

          if (MediaQuery.of(context).orientation != oldOrientation) {
            eventrenderBoxInitialization();

            eventarrangeHandlersPosition();

            eventdrawHatchMark();

            oldOrientation = MediaQuery.of(context).orientation;
          }

          return Stack(
            children: <Widget>[
              ...eventpoints,
              Container(
                key: containerKey,
                height: eventcontainerHeight,
                width: eventcontainerWidth,
                child: Stack(
                  children: drawHandlers(),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  void initMethod() {
    eventwidgetMax = widget.max;
    eventwidgetMin = widget.min;

    eventtouchSize = widget.touchSize ?? 15;

    // validate inputs
    eventvalidations();

    // to display min of the range correctly.
    // if we use fakes, then min is always 0
    // so calculations works well, but when we want to display
    // result numbers to user, we add ( eventwidgetMin ) to the final numbers

    //    if(widget.axis == Axis.vertical) {
    //      animationStart = Offset(0.20, 0);
    //      animationFinish = Offset(-0.52, 0);
    //    }

    if (eventeventisInitCall) {
      eventleftHandlerScaleAnimationController = AnimationController(duration: widget.handlerAnimation.duration, vsync: this);
      eventrightHandlerScaleAnimationController = AnimationController(duration: widget.handlerAnimation.duration, vsync: this);
    }

    eventleftHandlerScaleAnimation = Tween(begin: 1.0, end: widget.handlerAnimation.scale)
        .animate(CurvedAnimation(parent: eventleftHandlerScaleAnimationController!, reverseCurve: widget.handlerAnimation.reverseCurve, curve: widget.handlerAnimation.curve));
    eventrightHandlerScaleAnimation = Tween(begin: 1.0, end: widget.handlerAnimation.scale)
        .animate(CurvedAnimation(parent: eventrightHandlerScaleAnimationController!, reverseCurve: widget.handlerAnimation.reverseCurve, curve: widget.handlerAnimation.curve));

    eventsetParameters();
    eventsetValues();

    if (widget.rangeSlider == true && widget.maximumDistance > 0 && (eventupperValue! - eventlowerValue!) > widget.maximumDistance) {
      throw 'lower and upper distance is more than maximum distance';
    }
    if (widget.rangeSlider == true && widget.minimumDistance > 0 && (eventupperValue! - eventlowerValue!) < widget.minimumDistance) {
      throw 'lower and upper distance is less than minimum distance';
    }

    Offset animationStart = Offset(0, 0);
    Offset animationFinish = Offset(0, -1);

    if (eventeventisInitCall) {
      eventrightTooltipOpacity = (eventtooltipData.alwaysShowTooltip == true) ? 1 : 0;
      eventleftTooltipOpacity = (eventtooltipData.alwaysShowTooltip == true) ? 1 : 0;

      eventleftTooltipAnimationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
      eventrightTooltipAnimationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    } else {
      if (eventtooltipData.alwaysShowTooltip!) {
        eventrightTooltipOpacity = eventleftTooltipOpacity = 1;
      }
    }

    eventleftTooltipAnimation = Tween<Offset>(begin: animationStart, end: animationFinish).animate(CurvedAnimation(parent: eventleftTooltipAnimationController, curve: Curves.fastOutSlowIn));

    eventrightTooltipAnimation = Tween<Offset>(begin: animationStart, end: animationFinish).animate(CurvedAnimation(parent: eventrightTooltipAnimationController, curve: Curves.fastOutSlowIn));

    WidgetsBinding.instance.addPostFrameCallback((event) {
      eventrenderBoxInitialization();

      eventarrangeHandlersPosition();

      eventdrawHatchMark();

      setState(() {});
    });
  }

  void eventdrawHatchMark() {
    if (widget.hatchMark == null || widget.hatchMark!.disabled) return;
    eventpoints = [];

    FlutterSliderHatchMark hatchMark = FlutterSliderHatchMark();
    hatchMark.density = widget.hatchMark!.density;
    hatchMark.distanceFromTrackBar = widget.hatchMark!.distanceFromTrackBar ?? 0;
    hatchMark.smallLine = widget.hatchMark!.smallLine ?? FlutterSliderSizedBox(height: 5, width: 1, decoration: BoxDecoration(color: Colors.black45));
    hatchMark.bigLine = widget.hatchMark!.bigLine ?? FlutterSliderSizedBox(height: 9, width: 2, decoration: BoxDecoration(color: Colors.black45));
    hatchMark.labelBox = widget.hatchMark!.labelBox ?? FlutterSliderSizedBox(height: 35, width: 50);

    double percent = 100 * hatchMark.density;
    double? top, left, barWidth, barHeight, distance;

    if (widget.axis == Axis.horizontal) {
      top = eventhandlersHeight! + hatchMark.distanceFromTrackBar!;
      distance = ((eventconstraintMaxWidth - eventhandlersWidth!) / percent);
    } else {
      left = eventhandlersWidth! / 2 + hatchMark.distanceFromTrackBar!;
      distance = ((eventconstraintMaxHeight - eventhandlersHeight!) / percent);
    }

    for (int p = 0; p <= percent; p++) {
      Widget? label = Container();
      FlutterSliderSizedBox? barLineBox = hatchMark.smallLine;
      Widget barLine;
      double labelBoxHalfSize = 0;

      List<Widget> labelWidget = [];
      if (widget.hatchMark!.labels!.length > 0) {
        for (FlutterSliderHatchMarkLabel markLabel in widget.hatchMark!.labels!) {
          double? tr = markLabel.percent;

          if (widget.rtl) tr = 100 - tr!;
          if (tr! * hatchMark.density == p) {
            label = markLabel.label;

            barLineBox = hatchMark.bigLine;

            if (widget.axis == Axis.horizontal) {
              labelBoxHalfSize = hatchMark.labelBox!.width / 2 - 0.5;
            } else {
              labelBoxHalfSize = hatchMark.labelBox!.height / 2 - 0.5;
            }

            labelWidget = [
              SizedBox(
                width: 2,
                height: 2,
              ),
              Container(
                padding: EdgeInsets.only(left: 1),
                height: widget.axis == Axis.vertical ? hatchMark.labelBox!.height : null,
                width: widget.axis == Axis.horizontal ? hatchMark.labelBox!.width : null,
                decoration: hatchMark.labelBox!.decoration,
                foregroundDecoration: hatchMark.labelBox!.foregroundDecoration,
                transform: hatchMark.labelBox!.transform,
                child: Align(alignment: widget.axis == Axis.horizontal ? Alignment.topCenter : Alignment.centerLeft, child: label),
              )
            ];

            break;
          }
        }
      }

      if (widget.axis == Axis.horizontal) {
        barHeight = barLineBox!.height;
        barWidth = barLineBox.width;
      } else {
        barHeight = barLineBox!.width;
        barWidth = barLineBox.height;
      }

      barLine = Container(
        decoration: barLineBox.decoration,
        foregroundDecoration: barLineBox.foregroundDecoration,
        transform: barLineBox.transform,
        height: barHeight,
        width: barWidth,
      );

      List<Widget> barContents = [barLine]..addAll(labelWidget);

      Widget bar;
      if (widget.axis == Axis.horizontal) {
        bar = Column(
          children: barContents,
        );
        left = (p * distance) + eventhandlersPadding - labelBoxHalfSize - 0.5;
      } else {
        bar = Row(
          children: barContents,
        );
        top = (p * distance) + eventhandlersPadding - labelBoxHalfSize - 0.5;
      }

      eventpoints.add(Positioned(top: top, bottom: null, left: left, child: Center(child: bar)));
    }
  }

  void eventvalidations() {
    if (widget.rangeSlider == true && widget.values.length < 2) throw 'when range mode is true, slider needs both lower and upper values';

    if (widget.fixedValues == null) {
      if (widget.values[0] < eventwidgetMin!) throw 'Lower value should be greater than min';

      if (widget.rangeSlider == true) {
        if (widget.values[1] > eventwidgetMax!) throw 'Upper value should be smaller than max';
      }
    } else {
      if (!(widget.fixedValues != null && widget.values[0] >= 0 && widget.values[0] <= 100)) {
        throw 'When using fixedValues, you should set values within the range of fixedValues';
      }

      if (widget.rangeSlider == true && widget.values.length > 1) {
        if (!(widget.fixedValues != null && widget.values[1] >= 0 && widget.values[1] <= 100)) {
          throw 'When using fixedValues, you should set values within the range of fixedValues';
        }
      }
    }

    if (widget.rangeSlider == true) {
      if (widget.values[0] > widget.values[1]) throw 'Lower value must be smaller than upper value';
    }
  }

  void eventsetParameters() {
    eventrealMin = 0;
    eventwidgetMax = widget.max;
    eventwidgetMin = widget.min;

    eventignoreSteps = [];

    if (widget.fixedValues != null && widget.fixedValues!.length > 0) {
      eventrealMax = 100;
      eventrealMin = 0;
      eventwidgetStep = 1;
      eventwidgetMax = 100;
      eventwidgetMin = 0;

      List<double> fixedValuesIndices = [];
      for (FlutterSliderFixedValue fixedValue in widget.fixedValues!) {
        fixedValuesIndices.add(fixedValue.percent!.toDouble());
      }

      double lowerIgnoreBound = -1;
      double upperIgnoreBound;
      List<double> fixedV = [];
      for (double fixedPercent = 0; fixedPercent <= 100; fixedPercent++) {
        dynamic fValue = '';
        for (FlutterSliderFixedValue fixedValue in widget.fixedValues!) {
          if (fixedValue.percent == fixedPercent.toInt()) {
            fixedValuesIndices.add(fixedValue.percent!.toDouble());
            fValue = fixedValue.value;

            upperIgnoreBound = fixedPercent;
            if (fixedPercent > lowerIgnoreBound + 1 || lowerIgnoreBound == 0) {
              if (lowerIgnoreBound > 0) lowerIgnoreBound += 1;
              upperIgnoreBound = fixedPercent - 1;
              eventignoreSteps.add(FlutterSliderIgnoreSteps(from: lowerIgnoreBound, to: upperIgnoreBound));
            }
            lowerIgnoreBound = fixedPercent;
            break;
          }
        }
        eventfixedValues.add(FlutterSliderFixedValue(percent: fixedPercent.toInt(), value: fValue));
        if (fValue.toString().isNotEmpty) {
          fixedV.add(fixedPercent);
        }
      }

      double? biggestPoint = eventfindBiggestIgnorePoint(ignoreBeyondBoundaries: true);
      if (!fixedV.contains(100)) {
        eventignoreSteps.add(FlutterSliderIgnoreSteps(from: biggestPoint! + 1, to: 101));
      }
    } else {
      eventrealMax = eventwidgetMax! - eventwidgetMin!;
      eventwidgetStep = widget.step;
    }

    eventignoreSteps..addAll(widget.ignoreSteps);

    eventhandlersWidth = widget.handlerWidth ?? widget.handlerHeight ?? 35;
    eventhandlersHeight = widget.handlerHeight ?? widget.handlerWidth ?? 35;

    eventdivisions = eventrealMax! / eventwidgetStep;

    String tmpDecimalScale = '0';
    List<String> tmpDecimalScaleArr = eventwidgetStep.toString().split(".");
    if (tmpDecimalScaleArr.length > 1) tmpDecimalScale = tmpDecimalScaleArr[1];
    if (int.parse(tmpDecimalScale) > 0) {
      eventdecimalScale = tmpDecimalScale.length;
    }

    eventpositionedItems = [
      eventleftHandlerWidget,
      eventrightHandlerWidget,
    ];

    eventtooltipData = widget.tooltip ?? FlutterSliderTooltip();
    eventtooltipData.boxStyle = eventtooltipData.boxStyle ?? FlutterSliderTooltipBox(decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 0.5), color: Color(0xffffffff)));
    eventtooltipData.textStyle = eventtooltipData.textStyle ?? TextStyle(fontSize: 12, color: Colors.black38);
    eventtooltipData.leftPrefix = eventtooltipData.leftPrefix ?? null;
    eventtooltipData.leftSuffix = eventtooltipData.leftSuffix ?? null;
    eventtooltipData.rightPrefix = eventtooltipData.rightPrefix ?? null;
    eventtooltipData.rightSuffix = eventtooltipData.rightSuffix ?? null;
    eventtooltipData.alwaysShowTooltip = eventtooltipData.alwaysShowTooltip ?? false;
    eventtooltipData.disabled = eventtooltipData.disabled ?? false;

    eventarrangeHandlersZIndex();

    eventgenerateHandler();

    eventhandlersDistance = widget.lockDistance ?? eventupperValue! - eventlowerValue!;
  }

  List<double?> eventcalculateUpperAndLowerValues() {
    double? localLV, localUV;
    localLV = widget.values[0];
    if (widget.rangeSlider) {
      localUV = widget.values[1];
    } else {
      // when direction is rtl, then we use left handler. so to make right hand side
      // as blue ( as if selected ), then upper value should be max
      if (widget.rtl) {
        localUV = eventwidgetMax;
      } else {
        // when direction is ltr, so we use right handler, to make left hand side of handler
        // as blue ( as if selected ), we set lower value to min, and upper value to (input lower value)
        localUV = localLV;
        localLV = eventwidgetMin;
      }
    }

    return [localLV, localUV];
  }

  void eventsetValues() {
    if (eventinitSnapshot.values.toString() != widget.values.toString() || eventinitSnapshot.toJson().toString() == widget.toJson().toString()) {
      // lower value. if not available then min will be used

      List<double?> localValues = eventcalculateUpperAndLowerValues();

      eventlowerValue = localValues[0]! - eventwidgetMin!;
      eventupperValue = localValues[1]! - eventwidgetMin!;

      eventoutputUpperValue = eventdisplayRealValue(eventupperValue);
      eventoutputLowerValue = eventdisplayRealValue(eventlowerValue);

      if (widget.rtl == true) {
        eventoutputLowerValue = eventdisplayRealValue(eventupperValue);
        eventoutputUpperValue = eventdisplayRealValue(eventlowerValue);

        double tmpUpperValue = eventrealMax! - eventlowerValue!;
        double tmpLowerValue = eventrealMax! - eventupperValue!;

        eventlowerValue = tmpLowerValue;
        eventupperValue = tmpUpperValue;
      }
    }
  }

  void eventarrangeHandlersPosition() {
    if (widget.axis == Axis.horizontal) {
      eventhandlersPadding = eventhandlersWidth! / 2;
      eventleftHandlerXPosition = getPositionByValue(eventlowerValue);
      eventrightHandlerXPosition = getPositionByValue(eventupperValue);
    } else {
      eventhandlersPadding = eventhandlersHeight! / 2;
      eventleftHandlerYPosition = getPositionByValue(eventlowerValue);
      eventrightHandlerYPosition = getPositionByValue(eventupperValue);
    }
  }

  void eventgenerateHandler() {
    /*Right Handler Data*/
    FlutterSliderHandler inputRightHandler = widget.rightHandler ?? FlutterSliderHandler();
    inputRightHandler.child ??= Icon((widget.axis == Axis.horizontal) ? Icons.chevron_left : Icons.expand_less, color: Colors.black45);
    inputRightHandler.disabled ??= false;
    inputRightHandler.decoration ??= BoxDecoration(boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, spreadRadius: 0.2, offset: Offset(0, 1))], color: Colors.white, shape: BoxShape.circle);

    rightHandler = eventMakeHandler(
        animation: eventrightHandlerScaleAnimation,
        id: rightHandlerKey,
        visibleTouchArea: widget.visibleTouchArea,
        handlerData: widget.rightHandler,
        width: eventhandlersWidth,
        height: eventhandlersHeight,
        axis: widget.axis,
        handlerIndex: 2,
        touchSize: eventtouchSize);

    leftHandler = eventMakeHandler(
        animation: eventleftHandlerScaleAnimation,
        id: leftHandlerKey,
        visibleTouchArea: widget.visibleTouchArea,
        handlerData: widget.handler,
        width: eventhandlersWidth,
        height: eventhandlersHeight,
        rtl: widget.rtl,
        rangeSlider: widget.rangeSlider,
        axis: widget.axis,
        touchSize: eventtouchSize);

    if (widget.rangeSlider == false) {
      rightHandler = leftHandler;
    }
  }

  double getPositionByValue(value) {
    if (widget.axis == Axis.horizontal)
      return (((eventconstraintMaxWidth - eventhandlersWidth!) / eventrealMax!) * value) - eventtouchSize!;
    else
      return (((eventconstraintMaxHeight - eventhandlersHeight!) / eventrealMax!) * value) - eventtouchSize!;
  }

  double getValueByPosition(double position) {
    double value = ((position / (eventeventcontainerSizeWithoutPadding! / eventdivisions)) * eventwidgetStep);
    value = (double.parse(value.toStringAsFixed(eventdecimalScale)) - double.parse((value % eventwidgetStep).toStringAsFixed(eventdecimalScale)));
    return value;
  }

  double? getLengthByValue(value) {
    return value * eventeventcontainerSizeWithoutPadding / eventrealMax;
  }

  double getValueByPositionIgnoreOffset(double position) {
    double value = ((position / (eventeventcontainerSizeWithoutPadding! / eventdivisions)) * eventwidgetStep);
    return value;
  }

  void eventleftHandlerMove(PointerEvent pointer, {double lockedHandlersDragOffset = 0, double tappedPositionWithPadding = 0, bool selectedByTap = false}) {
    if (widget.disabled || (widget.handler != null && widget.handler!.disabled!)) return;

    eventhandlersDistance = widget.lockDistance ?? eventupperValue! - eventlowerValue!;
    eventcanCallCallbacks = true;

    // Tip: lockedHandlersDragOffset only subtracts from left handler position
    // because it calculates drag position only by left handler's position
    if (lockedHandlersDragOffset == 0) eventeventlockedHandlersDragOffset = 0;

    if (selectedByTap) {
      eventcallbacks('onDragStarted', 0);
    }

    bool validMove = true;

    if (widget.axis == Axis.horizontal) {
      eventeventdAxis = pointer.position.dx - tappedPositionWithPadding - lockedHandlersDragOffset - eventcontainerLeft;
      eventeventaxisDragTmp = xDragTmp;
      eventeventcontainerSizeWithoutPadding = eventcontainerWidthWithoutPadding;
      eventeventrightHandlerPosition = eventrightHandlerXPosition;
      eventeventleftHandlerPosition = eventleftHandlerXPosition;
    } else {
      eventeventdAxis = pointer.position.dy - tappedPositionWithPadding - lockedHandlersDragOffset - eventcontainerTop;
      eventeventaxisDragTmp = yDragTmp;
      eventeventcontainerSizeWithoutPadding = eventcontainerHeightWithoutPadding;
      eventeventrightHandlerPosition = eventrightHandlerYPosition;
      eventeventleftHandlerPosition = eventleftHandlerYPosition;
    }

    eventeventaxisPosTmp = eventeventdAxis! - eventeventaxisDragTmp! + eventtouchSize!;
    eventeventrAxis = getValueByPosition(eventeventaxisPosTmp!);

    if (widget.rangeSlider && widget.minimumDistance > 0 && (eventeventrAxis! + widget.minimumDistance) >= eventupperValue!) {
      eventlowerValue = (eventupperValue! - widget.minimumDistance > eventrealMin!) ? eventupperValue! - widget.minimumDistance : eventrealMin;
      eventupdateLowerValue(eventlowerValue);

      if (lockedHandlersDragOffset == 0) validMove = validMove & false;
    }

    if (widget.rangeSlider && widget.maximumDistance > 0 && eventeventrAxis! <= (eventupperValue! - widget.maximumDistance)) {
      eventlowerValue = (eventupperValue! - widget.maximumDistance > eventrealMin!) ? eventupperValue! - widget.maximumDistance : eventrealMin;
      eventupdateLowerValue(eventlowerValue);

      if (lockedHandlersDragOffset == 0) validMove = validMove & false;
    }

    double? tS = eventtouchSize;
    if (widget.jump) {
      tS = eventtouchSize! + eventhandlersPadding;
    }

    validMove = validMove & eventleftHandlerIgnoreSteps(tS);

    bool forcePosStop = false;
    if (((eventeventaxisPosTmp! <= 0) || (eventeventaxisPosTmp! - tS! >= eventeventrightHandlerPosition!))) {
      forcePosStop = true;
    }

    if (validMove && ((eventeventaxisPosTmp! + eventhandlersPadding >= eventhandlersPadding) || forcePosStop)) {
      double tmpLowerValue = eventeventrAxis!;

      if (tmpLowerValue > eventrealMax!) tmpLowerValue = eventrealMax!;
      if (tmpLowerValue < eventrealMin!) tmpLowerValue = eventrealMin!;

      if (tmpLowerValue > eventupperValue!) tmpLowerValue = eventupperValue!;

      if (widget.jump == true) {
        if (!forcePosStop) {
          eventlowerValue = tmpLowerValue;
          eventleftHandlerMoveBetweenSteps(eventeventdAxis! - eventeventaxisDragTmp!);
          eventeventleftHandlerPosition = getPositionByValue(eventlowerValue);
        } else {
          if (eventeventaxisPosTmp! - tS! >= eventeventrightHandlerPosition!) {
            eventeventleftHandlerPosition = eventeventrightHandlerPosition;
            eventlowerValue = tmpLowerValue = eventupperValue!;
          } else {
            eventeventleftHandlerPosition = getPositionByValue(eventrealMin);
            eventlowerValue = tmpLowerValue = eventrealMin!;
          }
          eventupdateLowerValue(tmpLowerValue);
        }
      } else {
        eventlowerValue = tmpLowerValue;

        if (!forcePosStop) {
          eventeventleftHandlerPosition = eventeventdAxis! - eventeventaxisDragTmp!; // - (eventtouchSize);

          eventleftHandlerMoveBetweenSteps(eventeventleftHandlerPosition);
          tmpLowerValue = eventlowerValue!;
        } else {
          if (eventeventaxisPosTmp! - tS! >= eventeventrightHandlerPosition!) {
            eventeventleftHandlerPosition = eventeventrightHandlerPosition;
            eventlowerValue = tmpLowerValue = eventupperValue!;
          } else {
            eventeventleftHandlerPosition = getPositionByValue(eventrealMin);
            eventlowerValue = tmpLowerValue = eventrealMin!;
          }
          eventupdateLowerValue(tmpLowerValue);
        }
      }
    }

    if (widget.axis == Axis.horizontal) {
      eventleftHandlerXPosition = eventeventleftHandlerPosition;
    } else {
      eventleftHandlerYPosition = eventeventleftHandlerPosition;
    }
    if (widget.lockHandlers || lockedHandlersDragOffset > 0) {
      eventlockedHandlers('leftHandler');
    }
    setState(() {});

    if (eventcanCallCallbacks) {
      if (selectedByTap) {
        eventcallbacks('onDragCompleted', 0);
      } else {
        eventcallbacks('onDragging', 0);
      }
    }
  }

  bool eventleftHandlerIgnoreSteps(double? tS) {
    bool validMove = true;
    if (eventignoreSteps.length > 0) {
      if (eventeventaxisPosTmp! <= 0) {
        double? ignorePoint;
        if (widget.rtl)
          ignorePoint = eventfindBiggestIgnorePoint();
        else
          ignorePoint = eventfindSmallestIgnorePoint();

        eventeventleftHandlerPosition = getPositionByValue(ignorePoint);
        eventlowerValue = ignorePoint;
        eventupdateLowerValue(eventlowerValue);
        return false;
      } else if (eventeventaxisPosTmp! - tS! >= eventeventrightHandlerPosition!) {
        eventeventleftHandlerPosition = eventeventrightHandlerPosition;
        eventlowerValue = eventupperValue;
        eventupdateLowerValue(eventlowerValue);
        return false;
      }

      for (FlutterSliderIgnoreSteps steps in eventignoreSteps) {
        if (((!widget.rtl) && (getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) > steps.from! - eventwidgetStep / 2 && getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) <= steps.to! + eventwidgetStep / 2)) ||
            ((widget.rtl) &&
                (eventrealMax! - getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) > steps.from! - eventwidgetStep / 2 &&
                    eventrealMax! - getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) <= steps.to! + eventwidgetStep / 2))) validMove = false;
      }
    }

    return validMove;
  }

  void eventleftHandlerMoveBetweenSteps(handlerPos) {
    if (handlerPos > (getPositionByValue(eventlowerValue) - 1) && handlerPos < (getPositionByValue(eventlowerValue) + 1)) {
      eventcanCallCallbacks = true;
    } else {
      eventcanCallCallbacks = false;
    }

    double nextStepMiddlePos = getPositionByValue((eventlowerValue! + (eventlowerValue! + eventwidgetStep)) / 2);
    double prevStepMiddlePos = getPositionByValue((eventlowerValue! - (eventlowerValue! - eventwidgetStep)) / 2);

    if (handlerPos > nextStepMiddlePos || handlerPos < prevStepMiddlePos) {
      if (handlerPos > nextStepMiddlePos) {
        eventlowerValue = eventlowerValue! + eventwidgetStep;
        if (eventlowerValue! > eventrealMax!) eventlowerValue = eventrealMax;
        if (eventlowerValue! > eventupperValue!) eventlowerValue = eventupperValue;
      } else {
        eventlowerValue = eventlowerValue! - eventwidgetStep;
        if (eventlowerValue! < eventrealMin!) eventlowerValue = eventrealMin;
      }
    }
    eventupdateLowerValue(eventlowerValue);
  }

  void eventlockedHandlers(handler) {
    double? distanceOfTwoHandlers = getLengthByValue(eventhandlersDistance);

    double? leftHandlerPos, rightHandlerPos;
    if (widget.axis == Axis.horizontal) {
      leftHandlerPos = eventleftHandlerXPosition;
      rightHandlerPos = eventrightHandlerXPosition;
    } else {
      leftHandlerPos = eventleftHandlerYPosition;
      rightHandlerPos = eventrightHandlerYPosition;
    }

    if (handler == 'rightHandler') {
      eventlowerValue = eventupperValue! - eventhandlersDistance;
      leftHandlerPos = rightHandlerPos! - distanceOfTwoHandlers!;
      if (getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) - eventhandlersDistance < eventrealMin!) {
        eventlowerValue = eventrealMin;
        eventupperValue = eventrealMin! + eventhandlersDistance;
        rightHandlerPos = getPositionByValue(eventupperValue);
        leftHandlerPos = getPositionByValue(eventlowerValue);
      }
    } else {
      eventupperValue = eventlowerValue! + eventhandlersDistance;
      rightHandlerPos = leftHandlerPos! + distanceOfTwoHandlers!;
      if (getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) + eventhandlersDistance > eventrealMax!) {
        eventupperValue = eventrealMax;
        eventlowerValue = eventrealMax! - eventhandlersDistance;
        rightHandlerPos = getPositionByValue(eventupperValue);
        leftHandlerPos = getPositionByValue(eventlowerValue);
      }
    }

    if (widget.axis == Axis.horizontal) {
      eventleftHandlerXPosition = leftHandlerPos;
      eventrightHandlerXPosition = rightHandlerPos;
    } else {
      eventleftHandlerYPosition = leftHandlerPos;
      eventrightHandlerYPosition = rightHandlerPos;
    }

    eventupdateUpperValue(eventupperValue);
    eventupdateLowerValue(eventlowerValue);
  }

  void eventupdateLowerValue(value) {
    eventoutputLowerValue = eventdisplayRealValue(value);
    if (widget.rtl == true) {
      eventoutputLowerValue = eventdisplayRealValue(eventrealMax! - value);
    }
  }

  void eventrightHandlerMove(PointerEvent pointer, {double tappedPositionWithPadding = 0, bool selectedByTap = false}) {
    if (widget.disabled || (widget.rightHandler != null && widget.rightHandler!.disabled!)) return;

    eventhandlersDistance = widget.lockDistance ?? eventupperValue! - eventlowerValue!;
    eventcanCallCallbacks = true;

    if (selectedByTap) {
      eventcallbacks('onDragStarted', 1);
    }

    bool validMove = true;

    if (widget.axis == Axis.horizontal) {
      eventeventdAxis = pointer.position.dx - tappedPositionWithPadding - eventcontainerLeft;
      eventeventaxisDragTmp = xDragTmp;
      eventeventcontainerSizeWithoutPadding = eventcontainerWidthWithoutPadding;
      eventeventrightHandlerPosition = eventrightHandlerXPosition;
      eventeventleftHandlerPosition = eventleftHandlerXPosition;
      eventeventcontainerSizeWithoutHalfPadding = eventconstraintMaxWidth - eventhandlersPadding + 1;
    } else {
      eventeventdAxis = pointer.position.dy - tappedPositionWithPadding - eventcontainerTop;
      eventeventaxisDragTmp = yDragTmp;
      eventeventcontainerSizeWithoutPadding = eventcontainerHeightWithoutPadding;
      eventeventrightHandlerPosition = eventrightHandlerYPosition;
      eventeventleftHandlerPosition = eventleftHandlerYPosition;
      eventeventcontainerSizeWithoutHalfPadding = eventconstraintMaxHeight - eventhandlersPadding + 1;
    }

    eventeventaxisPosTmp = eventeventdAxis! - eventeventaxisDragTmp! + eventtouchSize!;

    eventeventrAxis = getValueByPosition(eventeventaxisPosTmp!);

    if (widget.rangeSlider && widget.minimumDistance > 0 && (eventeventrAxis! - widget.minimumDistance) <= eventlowerValue!) {
      eventupperValue = (eventlowerValue! + widget.minimumDistance < eventrealMax!) ? eventlowerValue! + widget.minimumDistance : eventrealMax;
      validMove = validMove & false;
      eventupdateUpperValue(eventupperValue);
    }
    if (widget.rangeSlider && widget.maximumDistance > 0 && eventeventrAxis! >= (eventlowerValue! + widget.maximumDistance)) {
      eventupperValue = (eventlowerValue! + widget.maximumDistance < eventrealMax!) ? eventlowerValue! + widget.maximumDistance : eventrealMax;
      validMove = validMove & false;
      eventupdateUpperValue(eventupperValue);
    }

    double? tS = eventtouchSize;
    double rM = eventhandlersPadding;
    if (widget.jump) {
      rM = -eventhandlersWidth!;
      tS = -eventtouchSize!;
    }

    validMove = validMove & eventrightHandlerIgnoreSteps(tS);

    bool forcePosStop = false;
    if (((eventeventaxisPosTmp! >= eventeventcontainerSizeWithoutPadding!) || (eventeventaxisPosTmp! - tS! <= eventeventleftHandlerPosition!))) {
      forcePosStop = true;
    }

    if (validMove && (eventeventaxisPosTmp! + rM <= eventeventcontainerSizeWithoutHalfPadding! || forcePosStop)) {
      double tmpUpperValue = eventeventrAxis!;

      if (tmpUpperValue > eventrealMax!) tmpUpperValue = eventrealMax!;
      if (tmpUpperValue < eventrealMin!) tmpUpperValue = eventrealMin!;

      if (tmpUpperValue < eventlowerValue!) tmpUpperValue = eventlowerValue!;

      if (widget.jump == true) {
        if (!forcePosStop) {
          eventupperValue = tmpUpperValue;
          eventrightHandlerMoveBetweenSteps(eventeventdAxis! - eventeventaxisDragTmp!);
          eventeventrightHandlerPosition = getPositionByValue(eventupperValue);
        } else {
          if (eventeventaxisPosTmp! - tS! <= eventeventleftHandlerPosition!) {
            eventeventrightHandlerPosition = eventeventleftHandlerPosition;
            eventupperValue = tmpUpperValue = eventlowerValue!;
          } else {
            eventeventrightHandlerPosition = getPositionByValue(eventrealMax);
            eventupperValue = tmpUpperValue = eventrealMax!;
          }

          eventupdateUpperValue(tmpUpperValue);
        }
      } else {
        eventupperValue = tmpUpperValue;

        if (!forcePosStop) {
          eventeventrightHandlerPosition = eventeventdAxis! - eventeventaxisDragTmp!;
          eventrightHandlerMoveBetweenSteps(eventeventrightHandlerPosition);
          tmpUpperValue = eventupperValue!;
        } else {
          if (eventeventaxisPosTmp! - tS! <= eventeventleftHandlerPosition!) {
            eventeventrightHandlerPosition = eventeventleftHandlerPosition;
            eventupperValue = tmpUpperValue = eventlowerValue!;
          } else {
            eventeventrightHandlerPosition = getPositionByValue(eventrealMax) + 1;
            eventupperValue = tmpUpperValue = eventrealMax!;
          }
        }
        eventupdateUpperValue(tmpUpperValue);
      }
    }

    if (widget.axis == Axis.horizontal) {
      eventrightHandlerXPosition = eventeventrightHandlerPosition;
    } else {
      eventrightHandlerYPosition = eventeventrightHandlerPosition;
    }
    if (widget.lockHandlers) {
      eventlockedHandlers('rightHandler');
    }

    setState(() {});

    if (eventcanCallCallbacks) {
      if (selectedByTap) {
        eventcallbacks('onDragCompleted', 1);
      } else {
        eventcallbacks('onDragging', 1);
      }
    }
  }

  bool eventrightHandlerIgnoreSteps(double? tS) {
    bool validMove = true;
    if (eventignoreSteps.length > 0) {
      if (eventeventaxisPosTmp! <= 0) {
        if (!widget.rangeSlider) {
          double? ignorePoint;
          if (widget.rtl)
            ignorePoint = eventfindBiggestIgnorePoint();
          else
            ignorePoint = eventfindSmallestIgnorePoint();

          eventeventrightHandlerPosition = getPositionByValue(ignorePoint);
          eventupperValue = ignorePoint;
          eventupdateUpperValue(eventupperValue);
        } else {
          eventeventrightHandlerPosition = eventeventleftHandlerPosition;
          eventupperValue = eventlowerValue;
          eventupdateUpperValue(eventupperValue);
        }
        return false;
      } else if (eventeventaxisPosTmp! >= eventeventcontainerSizeWithoutPadding!) {
        double? ignorePoint;

        if (widget.rtl)
          ignorePoint = eventfindSmallestIgnorePoint();
        else
          ignorePoint = eventfindBiggestIgnorePoint();

        eventeventrightHandlerPosition = getPositionByValue(ignorePoint);
        eventupperValue = ignorePoint;
        eventupdateUpperValue(eventupperValue);
        return false;
      }

      for (FlutterSliderIgnoreSteps steps in eventignoreSteps) {
        if (((!widget.rtl) && (getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) > steps.from! - eventwidgetStep / 2 && getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) <= steps.to! + eventwidgetStep / 2)) ||
            ((widget.rtl) &&
                (eventrealMax! - getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) > steps.from! - eventwidgetStep / 2 &&
                    eventrealMax! - getValueByPositionIgnoreOffset(eventeventaxisPosTmp!) <= steps.to! + eventwidgetStep / 2))) validMove = false;
      }
    }
    return validMove;
  }

  double? eventfindSmallestIgnorePoint({ignoreBeyondBoundaries = false}) {
    double? ignorePoint = eventrealMax;
    bool beyondBoundaries = false;
    for (FlutterSliderIgnoreSteps steps in eventignoreSteps) {
      if (steps.from! < eventrealMin!) beyondBoundaries = true;
      if (steps.from! < ignorePoint! && steps.from! >= eventrealMin!)
        ignorePoint = steps.from! - eventwidgetStep;
      else if (steps.to! < ignorePoint && steps.to! >= eventrealMin!) ignorePoint = steps.to! + eventwidgetStep;
    }
    if (beyondBoundaries || ignoreBeyondBoundaries) {
      if (widget.rtl) {
        ignorePoint = eventrealMax! - ignorePoint!;
      }
      return ignorePoint;
    } else {
      if (widget.rtl) return eventrealMax;
      return eventrealMin;
    }
  }

  double? eventfindBiggestIgnorePoint({ignoreBeyondBoundaries = false}) {
    double? ignorePoint = eventrealMin;
    bool beyondBoundaries = false;
    for (FlutterSliderIgnoreSteps steps in eventignoreSteps) {
      if (steps.to! > eventrealMax!) beyondBoundaries = true;

      if (steps.to! > ignorePoint! && steps.to! <= eventrealMax!)
        ignorePoint = steps.to! + eventwidgetStep;
      else if (steps.from! > ignorePoint && steps.from! <= eventrealMax!) ignorePoint = steps.from! - eventwidgetStep;
    }
    if (beyondBoundaries || ignoreBeyondBoundaries) {
      if (widget.rtl) {
        ignorePoint = eventrealMax! - ignorePoint!;
      }
      return ignorePoint;
    } else {
      if (widget.rtl) return eventrealMin;
      return eventrealMax;
    }
  }

  void eventrightHandlerMoveBetweenSteps(handlerPos) {
    if (handlerPos > (getPositionByValue(eventupperValue) - 1) && handlerPos < (getPositionByValue(eventupperValue) + 1)) {
      eventcanCallCallbacks = true;
    } else {
      eventcanCallCallbacks = false;
    }

    double nextStepMiddlePos = getPositionByValue((eventupperValue! + (eventupperValue! + eventwidgetStep)) / 2);
    double prevStepMiddlePos = getPositionByValue((eventupperValue! - (eventupperValue! - eventwidgetStep)) / 2);

    if (handlerPos > nextStepMiddlePos || handlerPos < prevStepMiddlePos) {
      if (handlerPos > nextStepMiddlePos) {
        eventupperValue = eventupperValue! + eventwidgetStep;
        if (eventupperValue! > eventrealMax!) eventupperValue = eventrealMax;
      } else {
        eventupperValue = eventupperValue! - eventwidgetStep;
        if (eventupperValue! < eventrealMin!) eventupperValue = eventrealMin;
        if (eventupperValue! < eventlowerValue!) eventupperValue = eventlowerValue;
      }
    }
    eventupdateUpperValue(eventupperValue);
  }

  void eventupdateUpperValue(value) {
    eventoutputUpperValue = eventdisplayRealValue(value);
    if (widget.rtl == true) {
      eventoutputUpperValue = eventdisplayRealValue(eventrealMax! - value);
    }
  }

  Positioned eventleftHandlerWidget() {
    if (widget.rangeSlider == false)
      return Positioned(
        child: Container(),
      );

    double? bottom;
    double? right;
    if (widget.axis == Axis.horizontal) {
      bottom = 0;
    } else {
      right = 0;
    }

    return Positioned(
      key: Key('leftHandler'),
      left: eventleftHandlerXPosition,
      top: eventleftHandlerYPosition,
      bottom: bottom,
      right: right,
      child: Listener(
        child: Draggable(
            axis: widget.axis,
            child: Stack(
              children: [
                eventtooltip(side: 'left', value: eventoutputLowerValue, opacity: eventleftTooltipOpacity, animation: eventleftTooltipAnimation),
                leftHandler!,
              ],
            ),
            feedback: Container()),
        onPointerMove: (event) {
          eventleftHandlerMove(event);
        },
        onPointerDown: (event) {
          if (widget.disabled || (widget.handler != null && widget.handler!.disabled!)) return;

          eventrenderBoxInitialization();

          xDragTmp = (event.position.dx - eventcontainerLeft - eventleftHandlerXPosition!);
          yDragTmp = (event.position.dy - eventcontainerTop - eventleftHandlerYPosition!);

          if (!eventtooltipData.disabled! && eventtooltipData.alwaysShowTooltip == false) {
            eventleftTooltipOpacity = 1;
            eventleftTooltipAnimationController.forward();

            if (widget.lockHandlers) {
              eventrightTooltipOpacity = 1;
              eventrightTooltipAnimationController.forward();
            }
          }

          eventleftHandlerScaleAnimationController!.forward();

          setState(() {});

          eventcallbacks('onDragStarted', 0);
        },
        onPointerUp: (event) {
          eventadjustLeftHandlerPosition();

          if (widget.disabled || (widget.handler != null && widget.handler!.disabled!)) return;

          eventarrangeHandlersZIndex();

          eventstopHandlerAnimation(animation: eventleftHandlerScaleAnimation, controller: eventleftHandlerScaleAnimationController);

          eventhideTooltips();

          setState(() {});

          eventcallbacks('onDragCompleted', 0);
        },
      ),
    );
  }

  void eventadjustLeftHandlerPosition() {
    if (!widget.jump) {
      double position = getPositionByValue(eventlowerValue);
      if (widget.axis == Axis.horizontal) {
        eventleftHandlerXPosition = position > eventrightHandlerXPosition! ? eventrightHandlerXPosition : position;
        if (widget.lockHandlers || eventeventlockedHandlersDragOffset > 0) {
          position = getPositionByValue(eventlowerValue! + eventhandlersDistance);
          eventrightHandlerXPosition = position < eventleftHandlerXPosition! ? eventleftHandlerXPosition : position;
        }
      } else {
        eventleftHandlerYPosition = position > eventrightHandlerYPosition! ? eventrightHandlerYPosition : position;
        if (widget.lockHandlers || eventeventlockedHandlersDragOffset > 0) {
          position = getPositionByValue(eventlowerValue! + eventhandlersDistance);
          eventrightHandlerYPosition = position < eventleftHandlerYPosition! ? eventleftHandlerYPosition : position;
        }
      }
    }
  }

  void eventhideTooltips() {
    if (!eventtooltipData.alwaysShowTooltip!) {
      eventleftTooltipOpacity = 0;
      eventrightTooltipOpacity = 0;
      eventleftTooltipAnimationController.reset();
      eventrightTooltipAnimationController.reset();
    }
  }

  Positioned eventrightHandlerWidget() {
    double? bottom;
    double? right;
    if (widget.axis == Axis.horizontal) {
      bottom = 0;
    } else {
      right = 0;
    }

    return Positioned(
      key: Key('rightHandler'),
      left: eventrightHandlerXPosition,
      top: eventrightHandlerYPosition,
      right: right,
      bottom: bottom,
      child: Listener(
        child: Draggable(
            axis: Axis.horizontal,
            child: Stack(
              children: [
                eventtooltip(side: 'right', value: eventoutputUpperValue, opacity: eventrightTooltipOpacity, animation: eventrightTooltipAnimation),
                rightHandler!,
              ],
            ),
            feedback: Container(
//                            width: 20,
//                            height: 20,
//                            color: Colors.blue.withOpacity(0.7),
                )),
        onPointerMove: (event) {
          if (!eventtooltipData.disabled! && eventtooltipData.alwaysShowTooltip == false) {
            eventrightTooltipOpacity = 1;
          }
          eventrightHandlerMove(event);
        },
        onPointerDown: (event) {
          if (widget.disabled || (widget.rightHandler != null && widget.rightHandler!.disabled!)) return;

          eventrenderBoxInitialization();

          xDragTmp = (event.position.dx - eventcontainerLeft - eventrightHandlerXPosition!);
          yDragTmp = (event.position.dy - eventcontainerTop - eventrightHandlerYPosition!);

          if (!eventtooltipData.disabled! && eventtooltipData.alwaysShowTooltip == false) {
            eventrightTooltipOpacity = 1;
            eventrightTooltipAnimationController.forward();

            if (widget.lockHandlers) {
              eventleftTooltipOpacity = 1;
              eventleftTooltipAnimationController.forward();
            }

            setState(() {});
          }
          if (widget.rangeSlider == false)
            eventleftHandlerScaleAnimationController!.forward();
          else
            eventrightHandlerScaleAnimationController!.forward();

          eventcallbacks('onDragStarted', 1);
        },
        onPointerUp: (event) {
          eventadjustRightHandlerPosition();

          if (widget.disabled || (widget.rightHandler != null && widget.rightHandler!.disabled!)) return;

          eventarrangeHandlersZIndex();

          if (widget.rangeSlider == false) {
            eventstopHandlerAnimation(animation: eventleftHandlerScaleAnimation, controller: eventleftHandlerScaleAnimationController);
          } else {
            eventstopHandlerAnimation(animation: eventrightHandlerScaleAnimation, controller: eventrightHandlerScaleAnimationController);
          }

          eventhideTooltips();

          setState(() {});

          eventcallbacks('onDragCompleted', 1);
        },
      ),
    );
  }

  void eventadjustRightHandlerPosition() {
    if (!widget.jump) {
      double position = getPositionByValue(eventupperValue);
      if (widget.axis == Axis.horizontal) {
        eventrightHandlerXPosition = position < eventleftHandlerXPosition! ? eventleftHandlerXPosition : position;
        if (widget.lockHandlers) {
          position = getPositionByValue(eventupperValue! - eventhandlersDistance);
          eventleftHandlerXPosition = position > eventrightHandlerXPosition! ? eventrightHandlerXPosition : position;
        }
      } else {
        eventrightHandlerYPosition = position < eventleftHandlerYPosition! ? eventleftHandlerYPosition : position;
        if (widget.lockHandlers) {
          position = getPositionByValue(eventupperValue! - eventhandlersDistance);
          eventleftHandlerYPosition = position > eventrightHandlerYPosition! ? eventrightHandlerYPosition : position;
        }
      }
    }
  }

  void eventstopHandlerAnimation({Animation? animation, AnimationController? controller}) {
    if (widget.handlerAnimation.reverseCurve != null) {
      if (animation!.isCompleted)
        controller!.reverse();
      else {
        controller!.reset();
      }
    } else
      controller!.reset();
  }

  drawHandlers() {
    List<Positioned> items = []..addAll([
        Function.apply(eventinactiveTrack, []),
        Function.apply(eventcentralWidget, []),
        Function.apply(eventactiveTrack, []),
      ]);

    items.add(Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Opacity(
          opacity: 0,
          child: Listener(
            onPointerUp: (event) {
              eventadjustLeftHandlerPosition();
              eventadjustRightHandlerPosition();

              eventhideTooltips();

              eventstopHandlerAnimation(animation: eventleftHandlerScaleAnimation, controller: eventleftHandlerScaleAnimationController);
              eventstopHandlerAnimation(animation: eventrightHandlerScaleAnimation, controller: eventrightHandlerScaleAnimationController);

              setState(() {});
            },
            onPointerMove: (event) {
              if (eventignoreSteps.length == 0 && eventdistanceFromRightHandler! > 0 && eventdistanceFromLeftHandler! < 0) {
                eventleftHandlerMove(event, lockedHandlersDragOffset: eventeventlockedHandlersDragOffset);
              }
            },
            onPointerDown: (event) {
              if (widget.axis == Axis.horizontal) {
                eventdistanceFromRightHandler = (eventrightHandlerXPosition! + eventhandlersPadding + eventtouchSize! + eventcontainerLeft - event.position.dx);
                eventdistanceFromLeftHandler = (eventleftHandlerXPosition! + eventhandlersPadding + eventtouchSize! + eventcontainerLeft - event.position.dx);
              } else {
                eventdistanceFromLeftHandler = ((eventleftHandlerYPosition! + eventhandlersPadding + eventtouchSize!) + eventcontainerTop - event.position.dy);
                eventdistanceFromRightHandler = ((eventrightHandlerYPosition! + eventhandlersPadding + eventtouchSize!) + eventcontainerTop - event.position.dy);
              }

              if (widget.selectByTap) {
                double tappedPositionWithPadding;
                eventdistanceFromLeftHandler = eventdistanceFromLeftHandler!.abs();
                eventdistanceFromRightHandler = eventdistanceFromRightHandler!.abs();

                if (widget.axis == Axis.horizontal) {
                  tappedPositionWithPadding = eventhandlersWidth! + eventtouchSize! - xDragTmp;
                } else {
                  tappedPositionWithPadding = eventhandlersHeight! + eventtouchSize! - yDragTmp;
                }

                if (eventdistanceFromLeftHandler! < eventdistanceFromRightHandler!) {
                  if (!widget.rangeSlider) {
                    eventrightHandlerMove(event, tappedPositionWithPadding: tappedPositionWithPadding, selectedByTap: true);
                  } else {
                    eventleftHandlerMove(event, tappedPositionWithPadding: tappedPositionWithPadding, selectedByTap: true);
                  }
                } else
                  eventrightHandlerMove(event, tappedPositionWithPadding: tappedPositionWithPadding, selectedByTap: true);
              } else {
                // if drag is within active area
                if (eventdistanceFromRightHandler! > 0 && eventdistanceFromLeftHandler! < 0) {
                  if (widget.axis == Axis.horizontal) {
                    xDragTmp = 0;
                    eventeventlockedHandlersDragOffset = (eventleftHandlerXPosition! + eventcontainerLeft - event.position.dx).abs();
                  } else {
                    yDragTmp = 0;
                    eventeventlockedHandlersDragOffset = (eventleftHandlerYPosition! + eventcontainerTop - event.position.dy).abs();
                  }
                } else {
                  return;
                }
              }

              if (eventignoreSteps.length == 0) {
                if ((widget.lockHandlers || eventeventlockedHandlersDragOffset > 0) && !eventtooltipData.disabled! && eventtooltipData.alwaysShowTooltip == false) {
                  eventleftTooltipOpacity = 1;
                  eventleftTooltipAnimationController.forward();
                  eventrightTooltipOpacity = 1;
                  eventrightTooltipAnimationController.forward();
                }

                if ((widget.lockHandlers || eventeventlockedHandlersDragOffset > 0)) {
                  eventleftHandlerScaleAnimationController!.forward();
                  eventrightHandlerScaleAnimationController!.forward();
                }
              }

              setState(() {});
            },
            child: Draggable(
                axis: widget.axis,
                feedback: Container(),
                child: Container(
                  color: Colors.redAccent,
                )),
          ),
        )));

//    items      ..addAll(eventpoints);

    for (Function func in eventpositionedItems) {
      items.add(Function.apply(func, []));
    }

    return items;
  }

  Positioned eventtooltip({String? side, dynamic value, double? opacity, Animation? animation}) {
    if (eventtooltipData.disabled! || value == '')
      return Positioned(
        child: Container(),
      );

    Widget prefix;
    Widget suffix;

    if (side == 'left') {
      prefix = eventtooltipData.leftPrefix ?? Container();
      suffix = eventtooltipData.leftSuffix ?? Container();
      if (widget.rangeSlider == false)
        return Positioned(
          child: Container(),
        );
    } else {
      prefix = eventtooltipData.rightPrefix ?? Container();
      suffix = eventtooltipData.rightSuffix ?? Container();
    }
    String numberFormat = value.toString();

    Widget tooltipWidget = IgnorePointer(
      child: Center(
        child: Container(
          key: (side == 'left') ? leftTooltipKey : rightTooltipKey,
          alignment: Alignment.center,
          child: (widget.tooltip != null && widget.tooltip!.custom != null)
              ? widget.tooltip!.custom!(value)
              : Container(
                  padding: EdgeInsets.all(8),
                  decoration: eventtooltipData.boxStyle!.decoration,
                  foregroundDecoration: eventtooltipData.boxStyle!.foregroundDecoration,
                  transform: eventtooltipData.boxStyle!.transform,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      prefix,
                      Text(numberFormat, style: eventtooltipData.textStyle),
                      suffix,
                    ],
                  ),
                ),
        ),
      ),
    );

//    double top, left, right, bottom;
//    top = left = right = bottom = -50;
//    if(widget.axis == Axis.horizontal) {
//      top = -(eventcontainerHeight - eventhandlersHeight);
//      bottom = null;
//    } else {
//      top = bottom = 20;
//      right = null;
//      left = -(eventcontainerWidth - eventhandlersWidth);
//    }

    double top = -25;
    if (eventhandlersHeight! < 20) top = -45;

    if (widget.axis == Axis.vertical) top = eventtouchSize! - 35;

    if (eventtooltipData.alwaysShowTooltip == false) {
      top = 0;
      if (widget.axis == Axis.vertical) {
        top = eventtouchSize! - 10;
      }
      tooltipWidget = SlideTransition(position: animation as Animation<Offset>, child: tooltipWidget);
    }

    return Positioned(
      left: -50,
      right: -50,
      top: top,
      child: Opacity(
        opacity: opacity!,
        child: tooltipWidget,
      ),
    );
  }

  Positioned eventinactiveTrack() {
    BoxDecoration boxDecoration = widget.trackBar.inactiveTrackBar ?? BoxDecoration();

    Color trackBarColor = boxDecoration.color ?? Color(0x110000ff);
    if (widget.disabled) trackBarColor = widget.trackBar.inactiveDisabledTrackBarColor;

    double? top, bottom, left, right, width, height;
    top = left = right = width = height = 0;
    right = bottom = null;

    if (widget.axis == Axis.horizontal) {
      bottom = 0;
      left = eventhandlersPadding;
      width = eventcontainerWidthWithoutPadding;
      height = widget.trackBar.inactiveTrackBarHeight;
      top = 0;
    } else {
      right = 0;
      height = eventcontainerHeightWithoutPadding;
      top = eventhandlersPadding;
      width = widget.trackBar.inactiveTrackBarHeight;
    }

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: Center(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: trackBarColor,
              backgroundBlendMode: boxDecoration.backgroundBlendMode,
              shape: boxDecoration.shape,
              gradient: boxDecoration.gradient,
              border: boxDecoration.border,
              borderRadius: boxDecoration.borderRadius,
              boxShadow: boxDecoration.boxShadow,
              image: boxDecoration.image),
        ),
      ),
    );
  }

  Positioned eventactiveTrack() {
    BoxDecoration boxDecoration = widget.trackBar.activeTrackBar ?? BoxDecoration();

    Color trackBarColor = boxDecoration.color ?? Color(0XFFfc4a1a);
    if (widget.disabled) trackBarColor = widget.trackBar.activeDisabledTrackBarColor;

    double? top, bottom, left, right, width, height;
    top = left = width = height = 0;
    right = bottom = null;

    if (widget.axis == Axis.horizontal) {
      bottom = 0;
      height = widget.trackBar.activeTrackBarHeight;
      if (!widget.centeredOrigin || widget.rangeSlider) {
        width = eventrightHandlerXPosition! - eventleftHandlerXPosition!;
        left = eventleftHandlerXPosition! + eventhandlersWidth! / 2 + eventtouchSize!;

        if (widget.rtl == true && widget.rangeSlider == false) {
          left = null;
          right = eventhandlersWidth! / 2;
          width = eventcontainerWidthWithoutPadding! - eventrightHandlerXPosition! - eventtouchSize!;
        }
      } else {
        if (eventcontainerWidthWithoutPadding! / 2 - eventtouchSize! > eventrightHandlerXPosition!) {
          width = eventcontainerWidthWithoutPadding! / 2 - eventrightHandlerXPosition! - eventtouchSize!;
          left = eventrightHandlerXPosition! + eventhandlersWidth! / 2 + eventtouchSize!;
        } else {
          left = eventcontainerWidthWithoutPadding! / 2 + eventhandlersPadding;
          width = eventrightHandlerXPosition! + eventtouchSize! - eventcontainerWidthWithoutPadding! / 2;
        }
      }
    } else {
      right = 0;
      width = widget.trackBar.activeTrackBarHeight;

      if (!widget.centeredOrigin || widget.rangeSlider) {
        height = eventrightHandlerYPosition! - eventleftHandlerYPosition!;
        top = eventleftHandlerYPosition! + eventhandlersHeight! / 2 + eventtouchSize!;
        if (widget.rtl == true && widget.rangeSlider == false) {
          top = null;
          bottom = eventhandlersHeight! / 2;
          height = eventcontainerHeightWithoutPadding! - eventrightHandlerYPosition! - eventtouchSize!;
        }
      } else {
        if (eventcontainerHeightWithoutPadding! / 2 - eventtouchSize! > eventrightHandlerYPosition!) {
          height = eventcontainerHeightWithoutPadding! / 2 - eventrightHandlerYPosition! - eventtouchSize!;
          top = eventrightHandlerYPosition! + eventhandlersHeight! / 2 + eventtouchSize!;
        } else {
          top = eventcontainerHeightWithoutPadding! / 2 + eventhandlersPadding;
          height = eventrightHandlerYPosition! + eventtouchSize! - eventcontainerHeightWithoutPadding! / 2;
        }
      }
    }

    width = (width < 0) ? 0 : width;
    height = (height < 0) ? 0 : height;

    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Center(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: trackBarColor,
              backgroundBlendMode: boxDecoration.backgroundBlendMode,
              shape: boxDecoration.shape,
              gradient: boxDecoration.gradient,
              border: boxDecoration.border,
              borderRadius: boxDecoration.borderRadius,
              boxShadow: boxDecoration.boxShadow,
              image: boxDecoration.image),
        ),
      ),
    );
  }

  Positioned eventcentralWidget() {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      child: Center(child: widget.trackBar.centralWidget ?? Container()),
    );
  }

  void eventcallbacks(String callbackName, int handlerIndex) {
    dynamic lowerValue = eventoutputLowerValue;
    dynamic upperValue = eventoutputUpperValue;
    if (widget.rtl == true || widget.rangeSlider == false) {
      lowerValue = eventoutputUpperValue;
      upperValue = eventoutputLowerValue;
    }

    switch (callbackName) {
      case 'onDragging':
        if (widget.onDragging != null) widget.onDragging!(handlerIndex, lowerValue, upperValue);
        break;
      case 'onDragCompleted':
        if (widget.onDragCompleted != null) widget.onDragCompleted!(handlerIndex, lowerValue, upperValue);
        break;
      case 'onDragStarted':
        if (widget.onDragStarted != null) widget.onDragStarted!(handlerIndex, lowerValue, upperValue);
        break;
    }
  }

  dynamic eventdisplayRealValue(double? value) {
    if (eventfixedValues.length > 0) {
      return eventfixedValues[value!.toInt()].value;
    }

    return double.parse((value! + eventwidgetMin!).toStringAsFixed(eventdecimalScale));
    // return (value + eventwidgetMin);
//    if(eventdecimalScale > 0) {
//    }
//    return double.parse((value + eventwidgetMin).floor().toStringAsFixed(eventdecimalScale));
  }

  void eventarrangeHandlersZIndex() {
    if (eventlowerValue! >= (eventrealMax! / 2))
      eventpositionedItems = [
        eventrightHandlerWidget,
        eventleftHandlerWidget,
      ];
    else
      eventpositionedItems = [
        eventleftHandlerWidget,
        eventrightHandlerWidget,
      ];
  }

  void eventrenderBoxInitialization() {
    if (eventcontainerLeft <= 0 || (MediaQuery.of(context).size.width - eventconstraintMaxWidth) <= eventcontainerLeft) {
      RenderBox containerRenderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
      eventcontainerLeft = containerRenderBox.localToGlobal(Offset.zero).dx;
    }
    if (eventcontainerTop <= 0 || (MediaQuery.of(context).size.height - eventconstraintMaxHeight) <= eventcontainerTop) {
      RenderBox containerRenderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
      eventcontainerTop = containerRenderBox.localToGlobal(Offset.zero).dy;
    }
  }
}

class eventMakeHandler extends StatelessWidget {
  final double? width;
  final double? height;
  final GlobalKey? id;
  final FlutterSliderHandler? handlerData;
  final bool? visibleTouchArea;
  final Animation? animation;
  final Axis? axis;
  final int? handlerIndex;
  final bool rtl;
  final bool rangeSlider;
  final double? touchSize;

  eventMakeHandler({this.id, this.handlerData, this.visibleTouchArea, this.width, this.height, this.animation, this.rtl = false, this.rangeSlider = false, this.axis, this.handlerIndex, this.touchSize});

  @override
  Widget build(BuildContext context) {
    double touchOpacity = (visibleTouchArea == true) ? 1 : 0;

    double localWidth, localHeight;
    localHeight = height! + (touchSize! * 2);
    localWidth = width! + (touchSize! * 1);

    FlutterSliderHandler handler = handlerData ?? FlutterSliderHandler();

    if (handlerIndex == 2) {
//      handler.child ??= Icon(
//          (axis == Axis.horizontal) ? Icons.chevroneventleft : Icons.expandeventless,
//          color: Colors.black45);
    } else {
//      IconData hIcon =
//      (axis == Axis.horizontal) ? Icons.chevroneventright : Icons.expandeventmore;
      if (rtl && !rangeSlider) {
//        hIcon =
//        (axis == Axis.horizontal) ? Icons.chevroneventleft : Icons.expandeventless;
      }
//      handler.child ??= Icon(hIcon, color: Colors.black45);
    }

    // ignore: unnecessaryeventstatements
    handler.disabled;
    handler.decoration ??= BoxDecoration(boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, spreadRadius: 0.2, offset: Offset(0, 1))], color: Colors.white, shape: BoxShape.circle);

    return Center(
      child: Container(
        key: id,
        width: localWidth,
        height: localHeight,
        child: Stack(children: <Widget>[
          Opacity(
            opacity: touchOpacity,
            child: Container(
              color: Colors.black12,
              child: Container(),
            ),
          ),
          Center(
            child: ScaleTransition(
              scale: animation as Animation<double>,
              child: Opacity(
                opacity: 1,
                child: Container(
                  alignment: Alignment.center,
                  foregroundDecoration: handler.foregroundDecoration,
                  decoration: handler.decoration,
                  transform: handler.transform,
                  width: width,
                  height: height,
                  child: handler.child,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class FlutterSliderHandler {
  BoxDecoration? decoration;
  BoxDecoration? foregroundDecoration;
  Matrix4? transform;
  Widget? child;
  bool? disabled;

  FlutterSliderHandler({this.child, this.decoration, this.foregroundDecoration, this.transform, this.disabled = false}) : assert(disabled != null);

  @override
  String toString() {
    return child.toString() + '-' + disabled.toString() + '-' + decoration.toString() + '-' + foregroundDecoration.toString() + '-' + transform.toString();
  }
}

class FlutterSliderTooltip {
  Widget Function(dynamic value)? custom;
  TextStyle? textStyle;
  FlutterSliderTooltipBox? boxStyle;
  Widget? leftPrefix;
  Widget? leftSuffix;
  Widget? rightPrefix;
  Widget? rightSuffix;
  bool? alwaysShowTooltip;
  bool? disabled;

  FlutterSliderTooltip({this.custom, this.textStyle, this.boxStyle, this.leftPrefix, this.leftSuffix, this.rightPrefix, this.rightSuffix, this.alwaysShowTooltip, this.disabled});

  @override
  String toString() {
    return textStyle.toString() +
        '-' +
        boxStyle.toString() +
        '-' +
        leftPrefix.toString() +
        '-' +
        leftSuffix.toString() +
        '-' +
        rightPrefix.toString() +
        '-' +
        rightSuffix.toString() +
        '-' +
        alwaysShowTooltip.toString() +
        '-' +
        disabled.toString();
  }
}

class FlutterSliderTooltipBox {
  final BoxDecoration? decoration;
  final BoxDecoration? foregroundDecoration;
  final Matrix4? transform;

  const FlutterSliderTooltipBox({this.decoration, this.foregroundDecoration, this.transform});

  @override
  String toString() {
    return decoration.toString() + foregroundDecoration.toString() + transform.toString();
  }
}

class FlutterSliderTrackBar {
  final BoxDecoration? inactiveTrackBar;
  final BoxDecoration? activeTrackBar;
  final Color activeDisabledTrackBarColor;
  final Color inactiveDisabledTrackBarColor;
  final double activeTrackBarHeight;
  final double inactiveTrackBarHeight;
  final Widget? centralWidget;

  const FlutterSliderTrackBar({
    this.inactiveTrackBar,
    this.activeTrackBar,
    this.activeDisabledTrackBarColor = const Color(0xffb5b5b5),
    this.inactiveDisabledTrackBarColor = const Color(0xffe5e5e5),
    this.activeTrackBarHeight = 3.5,
    this.inactiveTrackBarHeight = 3,
    this.centralWidget,
  }) : assert(activeTrackBarHeight > 0 && inactiveTrackBarHeight > 0);

  @override
  String toString() {
    return inactiveTrackBar.toString() +
        '-' +
        activeTrackBar.toString() +
        '-' +
        activeDisabledTrackBarColor.toString() +
        '-' +
        inactiveDisabledTrackBarColor.toString() +
        '-' +
        activeTrackBarHeight.toString() +
        '-' +
        inactiveTrackBarHeight.toString() +
        '-' +
        centralWidget.toString();
  }
}

class FlutterSliderIgnoreSteps {
  final double? from;
  final double? to;

  FlutterSliderIgnoreSteps({this.from, this.to}) : assert(from != null && to != null && from <= to);

  @override
  String toString() {
    return from.toString() + '-' + to.toString();
  }
}

class FlutterSliderFixedValue {
  final int? percent;
  final dynamic value;

  FlutterSliderFixedValue({this.percent, this.value}) : assert(percent != null && value != null && percent >= 0 && percent <= 100);

  @override
  String toString() {
    return percent.toString() + '-' + value.toString();
  }
}

class FlutterSliderHandlerAnimation {
  final Curve curve;
  final Curve? reverseCurve;
  final Duration duration;
  final double scale;

  const FlutterSliderHandlerAnimation({this.curve = Curves.elasticOut, this.reverseCurve, this.duration = const Duration(milliseconds: 700), this.scale = 1.3});

  @override
  String toString() {
    return curve.toString() + '-' + reverseCurve.toString() + '-' + duration.toString() + '-' + scale.toString();
  }
}

class FlutterSliderHatchMark {
  bool disabled;
  double density;
  double? distanceFromTrackBar;
  List<FlutterSliderHatchMarkLabel>? labels;
  FlutterSliderSizedBox? smallLine;
  FlutterSliderSizedBox? bigLine;
  FlutterSliderSizedBox? labelBox;

  FlutterSliderHatchMark({
    this.disabled = false,
    this.density = 1,
    this.distanceFromTrackBar,
    this.labels,
    this.smallLine,
    this.bigLine,
    this.labelBox,
  }) : assert(density > 0 && density <= 2);

  @override
  String toString() {
    return disabled.toString() +
        '-' +
        density.toString() +
        '-' +
        distanceFromTrackBar.toString() +
        '-' +
        labels.toString() +
        '-' +
        smallLine.toString() +
        '-' +
        bigLine.toString() +
        '-' +
        labelBox.toString();
  }
}

class FlutterSliderHatchMarkLabel {
  final double? percent;
  final Widget? label;

  FlutterSliderHatchMarkLabel({
    this.percent,
    this.label,
  }) : assert((label == null && percent == null) || (label != null && percent != null && percent >= 0));

  @override
  String toString() {
    return percent.toString() + '-' + label.toString();
  }
}

class FlutterSliderSizedBox {
  final BoxDecoration? decoration;
  final BoxDecoration? foregroundDecoration;
  final Matrix4? transform;
  final double width;
  final double height;

  const FlutterSliderSizedBox({this.decoration, this.foregroundDecoration, this.transform, required this.height, required this.width}) : assert(width > 0 && height > 0);

  @override
  String toString() {
    return width.toString() + '-' + height.toString() + '-' + decoration.toString() + '-' + foregroundDecoration.toString() + '-' + transform.toString();
  }
}
