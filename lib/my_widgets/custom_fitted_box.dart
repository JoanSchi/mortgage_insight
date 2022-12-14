import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

typedef CustomApplyBoxFit = FittedSizes Function(
    BoxFit _fit, Size inputSize, Size outputSize);

class CustomFittedBox extends SingleChildRenderObjectWidget {
  /// Creates a widget that scales and positions its child within itself according to [fit].
  ///
  /// The [fit] and [alignment] arguments must not be null.
  const CustomFittedBox({
    Key? key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.none,
    Widget? child,
    this.customApplyBoxFit,
  }) : super(key: key, child: child);

  final CustomApplyBoxFit? customApplyBoxFit;

  /// How to inscribe the child into the space allocated during layout.
  final BoxFit fit;

  /// How to align the child within its parent's bounds.
  ///
  /// An alignment of (-1.0, -1.0) aligns the child to the top-left corner of its
  /// parent's bounds. An alignment of (1.0, 0.0) aligns the child to the middle
  /// of the right edge of its parent's bounds.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none].
  final Clip clipBehavior;

  @override
  CustomRenderFittedBox createRenderObject(BuildContext context) {
    return CustomRenderFittedBox(
      customApplyBoxFit: customApplyBoxFit,
      fit: fit,
      alignment: alignment,
      textDirection: Directionality.maybeOf(context),
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, CustomRenderFittedBox renderObject) {
    renderObject
      ..customApplyBoxFit = customApplyBoxFit
      ..fit = fit
      ..alignment = alignment
      ..textDirection = Directionality.maybeOf(context)
      ..clipBehavior = clipBehavior;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<BoxFit>('fit', fit));
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
  }
}

FittedSizes defaultPieApplyBoxFit(_fit, Size inputSize, Size outputSize) {
  if (inputSize.height <= 0.0 ||
      inputSize.width <= 0.0 ||
      outputSize.height <= 0.0 ||
      outputSize.width <= 0.0) return const FittedSizes(Size.zero, Size.zero);

  final d = (outputSize.shortestSide / 2.0);
  final x = (inputSize.width / 2.0);
  final y = (inputSize.height / 2.0);

  final scale = math.sqrt(d * d / (x * x + y * y));

  Size sourceSize = inputSize;
  Size destinationSize = sourceSize * scale;
  return FittedSizes(sourceSize, destinationSize);
}

class CustomRenderFittedBox extends RenderProxyBox {
  /// Scales and positions its child within itself.
  ///
  /// The [fit] and [alignment] arguments must not be null.
  CustomRenderFittedBox({
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    TextDirection? textDirection,
    RenderBox? child,
    Clip clipBehavior = Clip.none,
    CustomApplyBoxFit? customApplyBoxFit,
  })  : _customApplyBoxFit = customApplyBoxFit,
        _fit = fit,
        _alignment = alignment,
        _textDirection = textDirection,
        _clipBehavior = clipBehavior,
        super(child);

  CustomApplyBoxFit? _customApplyBoxFit;

  CustomApplyBoxFit? get customApplyBoxFit => _customApplyBoxFit;

  set customApplyBoxFit(CustomApplyBoxFit? value) {
    if (_customApplyBoxFit == value) return;

    if (_customApplyBoxFit != value) {
      markNeedsLayout();
    }
  }

  Alignment? _resolvedAlignment;

  void _resolve() {
    if (_resolvedAlignment != null) return;
    _resolvedAlignment = alignment.resolve(textDirection);
  }

  void _markNeedResolution() {
    _resolvedAlignment = null;
    markNeedsPaint();
  }

  bool _fitAffectsLayout(BoxFit fit) {
    switch (fit) {
      case BoxFit.scaleDown:
        return true;
      case BoxFit.contain:
      case BoxFit.cover:
      case BoxFit.fill:
      case BoxFit.fitHeight:
      case BoxFit.fitWidth:
      case BoxFit.none:
        return false;
    }
  }

  /// How to inscribe the child into the space allocated during layout.
  BoxFit get fit => _fit;
  BoxFit _fit;
  set fit(BoxFit value) {
    if (_fit == value) return;
    final BoxFit lastFit = _fit;
    _fit = value;
    if (_fitAffectsLayout(lastFit) || _fitAffectsLayout(value)) {
      markNeedsLayout();
    } else {
      _clearPaintData();
      markNeedsPaint();
    }
  }

  /// How to align the child within its parent's bounds.
  ///
  /// An alignment of (0.0, 0.0) aligns the child to the top-left corner of its
  /// parent's bounds. An alignment of (1.0, 0.5) aligns the child to the middle
  /// of the right edge of its parent's bounds.
  ///
  /// If this is set to an [AlignmentDirectional] object, then
  /// [textDirection] must not be null.
  AlignmentGeometry get alignment => _alignment;
  AlignmentGeometry _alignment;
  set alignment(AlignmentGeometry value) {
    if (_alignment == value) return;
    _alignment = value;
    _clearPaintData();
    _markNeedResolution();
  }

  /// The text direction with which to resolve [alignment].
  ///
  /// This may be changed to null, but only after [alignment] has been changed
  /// to a value that does not depend on the direction.
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) return;
    _textDirection = value;
    _clearPaintData();
    _markNeedResolution();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child != null) {
      final Size childSize = child!.getDryLayout(const BoxConstraints());

      // During [RenderObject.debugCheckingIntrinsics] a child that doesn't
      // support dry layout may provide us with an invalid size that triggers
      // assertions if we try to work with it. Instead of throwing, we bail
      // out early in that case.
      bool invalidChildSize = false;
      assert(() {
        if (RenderObject.debugCheckingIntrinsics &&
            childSize.width * childSize.height == 0.0) {
          invalidChildSize = true;
        }
        return true;
      }());
      if (invalidChildSize) {
        assert(debugCannotComputeDryLayout(
          reason: 'Child provided invalid size of $childSize.',
        ));
        return Size.zero;
      }

      switch (fit) {
        case BoxFit.scaleDown:
          final BoxConstraints sizeConstraints = constraints.loosen();
          final Size unconstrainedSize = sizeConstraints
              .constrainSizeAndAttemptToPreserveAspectRatio(childSize);
          return constraints.constrain(unconstrainedSize);
        case BoxFit.contain:
        case BoxFit.cover:
        case BoxFit.fill:
        case BoxFit.fitHeight:
        case BoxFit.fitWidth:
        case BoxFit.none:
          return constraints
              .constrainSizeAndAttemptToPreserveAspectRatio(childSize);
      }
    } else {
      return constraints.smallest;
    }
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(const BoxConstraints(), parentUsesSize: true);
      switch (fit) {
        case BoxFit.scaleDown:
          final BoxConstraints sizeConstraints = constraints.loosen();
          final Size unconstrainedSize = sizeConstraints
              .constrainSizeAndAttemptToPreserveAspectRatio(child!.size);
          size = constraints.constrain(unconstrainedSize);
          break;
        case BoxFit.contain:
        case BoxFit.cover:
        case BoxFit.fill:
        case BoxFit.fitHeight:
        case BoxFit.fitWidth:
        case BoxFit.none:
          size = constraints
              .constrainSizeAndAttemptToPreserveAspectRatio(child!.size);
          break;
      }
      _clearPaintData();
    } else {
      size = constraints.smallest;
    }
  }

  bool? _hasVisualOverflow;
  Matrix4? _transform;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = Clip.none;
  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  void _clearPaintData() {
    _hasVisualOverflow = null;
    _transform = null;
  }

  void _updatePaintData() {
    if (_transform != null) return;

    if (child == null) {
      _hasVisualOverflow = false;
      _transform = Matrix4.identity();
    } else {
      _resolve();
      final Size childSize = child!.size;
      final FittedSizes sizes = _applyBoxFit(_fit, childSize, size);
      final double scaleX = sizes.destination.width / sizes.source.width;
      final double scaleY = sizes.destination.height / sizes.source.height;
      final Rect sourceRect =
          _resolvedAlignment!.inscribe(sizes.source, Offset.zero & childSize);
      final Rect destinationRect =
          _resolvedAlignment!.inscribe(sizes.destination, Offset.zero & size);
      _hasVisualOverflow = sourceRect.width < childSize.width ||
          sourceRect.height < childSize.height;
      assert(scaleX.isFinite && scaleY.isFinite);
      _transform = Matrix4.translationValues(
          destinationRect.left, destinationRect.top, 0.0)
        ..scale(scaleX, scaleY, 1.0)
        ..translate(-sourceRect.left, -sourceRect.top);
      assert(_transform!.storage.every((double value) => value.isFinite));
    }
  }

  FittedSizes _applyBoxFit(_fit, Size inputSize, Size outputSize) {
    if (customApplyBoxFit != null) {
      return customApplyBoxFit!(_fit, inputSize, outputSize);
    }
    return applyBoxFit(_fit, inputSize, outputSize);
  }

  FittedSizes applyBoxFitOrigineel(
      BoxFit fit, Size inputSize, Size outputSize) {
    if (inputSize.height <= 0.0 ||
        inputSize.width <= 0.0 ||
        outputSize.height <= 0.0 ||
        outputSize.width <= 0.0) return const FittedSizes(Size.zero, Size.zero);

    Size sourceSize, destinationSize;
    switch (fit) {
      case BoxFit.fill:
        sourceSize = inputSize;
        destinationSize = outputSize;
        break;
      case BoxFit.contain:
        sourceSize = inputSize;
        if (outputSize.width / outputSize.height >
            sourceSize.width / sourceSize.height)
          destinationSize = Size(
              sourceSize.width * outputSize.height / sourceSize.height,
              outputSize.height);
        else
          destinationSize = Size(outputSize.width,
              sourceSize.height * outputSize.width / sourceSize.width);
        break;
      case BoxFit.cover:
        if (outputSize.width / outputSize.height >
            inputSize.width / inputSize.height) {
          sourceSize = Size(inputSize.width,
              inputSize.width * outputSize.height / outputSize.width);
        } else {
          sourceSize = Size(
              inputSize.height * outputSize.width / outputSize.height,
              inputSize.height);
        }
        destinationSize = outputSize;
        break;
      case BoxFit.fitWidth:
        sourceSize = Size(inputSize.width,
            inputSize.width * outputSize.height / outputSize.width);
        destinationSize = Size(outputSize.width,
            sourceSize.height * outputSize.width / sourceSize.width);
        break;
      case BoxFit.fitHeight:
        sourceSize = Size(
            inputSize.height * outputSize.width / outputSize.height,
            inputSize.height);
        destinationSize = Size(
            sourceSize.width * outputSize.height / sourceSize.height,
            outputSize.height);
        break;
      case BoxFit.none:
        sourceSize = Size(math.min(inputSize.width, outputSize.width),
            math.min(inputSize.height, outputSize.height));
        destinationSize = sourceSize;
        break;
      case BoxFit.scaleDown:
        sourceSize = inputSize;
        destinationSize = inputSize;
        final double aspectRatio = inputSize.width / inputSize.height;
        if (destinationSize.height > outputSize.height)
          destinationSize =
              Size(outputSize.height * aspectRatio, outputSize.height);
        if (destinationSize.width > outputSize.width)
          destinationSize =
              Size(outputSize.width, outputSize.width / aspectRatio);
        break;
    }
    return FittedSizes(sourceSize, destinationSize);
  }

  TransformLayer? _paintChildWithTransform(
      PaintingContext context, Offset offset) {
    final Offset? childOffset = MatrixUtils.getAsTranslation(_transform!);
    if (childOffset == null)
      return context.pushTransform(
        needsCompositing,
        offset,
        _transform!,
        super.paint,
        oldLayer: layer is TransformLayer ? layer! as TransformLayer : null,
      );
    else
      super.paint(context, offset + childOffset);
    return null;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || size.isEmpty || child!.size.isEmpty) return;
    _updatePaintData();
    assert(child != null);
    if (_hasVisualOverflow! && clipBehavior != Clip.none) {
      layer = context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        _paintChildWithTransform,
        oldLayer: layer is ClipRectLayer ? layer! as ClipRectLayer : null,
        clipBehavior: clipBehavior,
      );
    } else {
      layer = _paintChildWithTransform(context, offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (size.isEmpty || child?.size.isEmpty == true) return false;
    _updatePaintData();
    return result.addWithPaintTransform(
      transform: _transform,
      position: position,
      hitTest: (BoxHitTestResult result, Offset position) {
        return super.hitTestChildren(result, position: position);
      },
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    if (size.isEmpty || child.size.isEmpty) {
      transform.setZero();
    } else {
      _updatePaintData();
      transform.multiply(_transform!);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
