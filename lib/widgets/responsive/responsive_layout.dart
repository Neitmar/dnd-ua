import 'package:flutter/material.dart';

/// Точки розриву для адаптивних лайаутів
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1200;
  static const double desktop = 1920;
}

/// Контекст адаптивної ширини екрану
class ResponsiveContext {
  final double screenWidth;
  final double screenHeight;

  ResponsiveContext({
    required this.screenWidth,
    required this.screenHeight,
  });

  /// < 600px
  bool get isMobile => screenWidth < ResponsiveBreakpoints.mobile;

  /// 600-1200px
  bool get isTablet =>
      screenWidth >= ResponsiveBreakpoints.mobile &&
      screenWidth < ResponsiveBreakpoints.tablet;

  /// >= 1200px
  bool get isDesktop => screenWidth >= ResponsiveBreakpoints.tablet;

  /// < 1200px (mobile or tablet)
  bool get isSmallScreen => screenWidth < ResponsiveBreakpoints.tablet;

  /// >= 1200px (desktop or larger)
  bool get isLargeScreen => screenWidth >= ResponsiveBreakpoints.tablet;
}

/// Універсальне адаптивне розташування
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < ResponsiveBreakpoints.mobile) {
      return mobile;
    }

    if (width < ResponsiveBreakpoints.tablet) {
      return tablet ?? mobile;
    }

    return desktop ?? tablet ?? mobile;
  }
}

/// Гнучкий рядок з адаптивною кількістю колон
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    late int columns;
    if (width < ResponsiveBreakpoints.mobile) {
      columns = mobileColumns;
    } else if (width < ResponsiveBreakpoints.tablet) {
      columns = tabletColumns;
    } else {
      columns = desktopColumns;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Обертка для отримання поточного ResponsiveContext
extension ResponsiveExtension on BuildContext {
  ResponsiveContext get responsive {
    final size = MediaQuery.of(this).size;
    return ResponsiveContext(
      screenWidth: size.width,
      screenHeight: size.height,
    );
  }

  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
  bool get isSmallScreen => responsive.isSmallScreen;
  bool get isLargeScreen => responsive.isLargeScreen;
}

/// Адаптивна вертикальна колона
class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool shrinkWrap;
  final bool scrollable;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.shrinkWrap = false,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final column = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );

    if (scrollable) {
      return SingleChildScrollView(
        padding: padding,
        child: column,
      );
    }

    if (padding != null) {
      return Padding(padding: padding!, child: column);
    }

    return column;
  }
}

/// Адаптивна горизонтальна лінія
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }
}
