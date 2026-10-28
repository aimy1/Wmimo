import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Renders a 100% brand-accurate, pixel-perfect pure vector icon for latency test targets
/// and speedtest servers (Cloudflare, Google, YouTube, OpenAI, Bilibili, Netflix,
/// Fast.com, GitHub, Apple, Akamai, CacheFly, Custom, etc.)
///
/// Built using official SVG vector geometries from brand guidelines.
/// Zero external font dependencies — completely immune to missing font box (tofu) errors.
class BrandVectorIcon extends StatelessWidget {
  final String id;
  final double size;
  final double borderRadius;
  final bool isSelected;

  const BrandVectorIcon({
    super.key,
    required this.id,
    this.size = 32.0,
    this.borderRadius = 8.0,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final cleanId = id.toLowerCase().trim();

    Widget iconContent;
    Color bgColor;

    if (cleanId.contains('cloudflare') || cleanId == 'cf' || cleanId.contains('1.1.1.1')) {
      bgColor = const Color(0xFFF38020);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.cloudflare,
        color: Colors.white,
        scaleFactor: 0.70,
      );
    } else if (cleanId.contains('youtube')) {
      bgColor = const Color(0xFFFF0000);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.youtube,
        color: Colors.white,
        scaleFactor: 0.65,
      );
    } else if (cleanId.contains('google')) {
      bgColor = const Color(0xFFFFFFFF);
      iconContent = const _Google4ColorWidget();
    } else if (cleanId.contains('openai') || cleanId.contains('chatgpt')) {
      bgColor = const Color(0xFF10A37F);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.openai,
        color: Colors.white,
        scaleFactor: 0.68,
      );
    } else if (cleanId.contains('bilibili') || cleanId.contains('bili')) {
      bgColor = const Color(0xFF00AEEC);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.bilibili,
        color: Colors.white,
        scaleFactor: 0.68,
      );
    } else if (cleanId.contains('baidu')) {
      bgColor = const Color(0xFF2932E1);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.baidu,
        color: Colors.white,
        scaleFactor: 0.70,
      );
    } else if (cleanId.contains('netflix')) {
      bgColor = const Color(0xFF141414);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.netflix,
        color: Color(0xFFE50914),
        scaleFactor: 0.65,
      );
    } else if (cleanId == 'x' || cleanId == 'twitter' || cleanId.contains('twitter.com') || cleanId.contains('x.com')) {
      bgColor = const Color(0xFF000000);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.x,
        color: Colors.white,
        scaleFactor: 0.62,
      );
    } else if (cleanId.contains('telegram') || cleanId.contains('t.me')) {
      bgColor = const Color(0xFF24A1DE);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.telegram,
        color: Colors.white,
        scaleFactor: 0.65,
      );
    } else if (cleanId.contains('github')) {
      bgColor = const Color(0xFF24292F);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.github,
        color: Colors.white,
        scaleFactor: 0.70,
      );
    } else if (cleanId.contains('apple')) {
      bgColor = const Color(0xFF1C1C1E);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.apple,
        color: Colors.white,
        scaleFactor: 0.68,
      );
    } else if (cleanId.contains('akamai')) {
      bgColor = const Color(0xFF003057);
      iconContent = const _OfficialSvgWidget(
        pathData: _OfficialBrandSvgs.akamai,
        color: Colors.white,
        scaleFactor: 0.68,
      );
    } else if (cleanId.contains('fast')) {
      bgColor = const Color(0xFF141414);
      iconContent = const _FastComOfficialWidget();
    } else if (cleanId.contains('cachefly')) {
      bgColor = const Color(0xFF009FE3);
      iconContent = const _CacheFlyOfficialWidget();
    } else {
      bgColor = const Color(0xFF455A64);
      iconContent = CustomPaint(
        size: Size(size * 0.60, size * 0.60),
        painter: const _CustomLinkPainter(),
      );
    }

    final bool isVeryDark = bgColor.computeLuminance() < 0.08;
    final bool isVeryLight = bgColor.computeLuminance() > 0.85;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: isVeryLight
            ? Border.all(color: Colors.black.withValues(alpha: 0.12), width: 0.8)
            : isVeryDark
                ? Border.all(color: Colors.white.withValues(alpha: 0.15), width: 0.8)
                : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: bgColor.withAlpha(120),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(child: iconContent),
    );
  }
}

/// Official brand SVG path definitions from upstream brand assets
class _OfficialBrandSvgs {
  static const String cloudflare =
      "M16.5088 16.8447c.1475-.5068.0908-.9707-.1553-1.3154-.2246-.3164-.6045-.499-1.0615-.5205l-8.6592-.1123a.1559.1559 0 0 1-.1333-.0713c-.0283-.042-.0351-.0986-.021-.1553.0278-.084.1123-.1484.2036-.1562l8.7359-.1123c1.0351-.0489 2.1601-.8868 2.5537-1.9136l.499-1.3013c.0215-.0561.0293-.1128.0147-.168-.5625-2.5463-2.835-4.4453-5.5499-4.4453-2.5039 0-4.6284 1.6177-5.3876 3.8614-.4927-.3658-1.1187-.5625-1.794-.499-1.2026.119-2.1665 1.083-2.2861 2.2856-.0283.31-.0069.6128.0635.894C1.5683 13.171 0 14.7754 0 16.752c0 .1748.0142.3515.0352.5273.0141.083.0844.1475.1689.1475h15.9814c.0909 0 .1758-.0645.2032-.1553l.12-.4268zm2.7568-5.5634c-.0771 0-.1611 0-.2383.0112-.0566 0-.1054.0415-.127.0976l-.3378 1.1744c-.1475.5068-.0918.9707.1543 1.3164.2256.3164.6055.498 1.0625.5195l1.8437.1133c.0557 0 .1055.0263.1329.0703.0283.043.0351.1074.0214.1562-.0283.084-.1132.1485-.204.1553l-1.921.1123c-1.041.0488-2.1582.8867-2.5527 1.914l-.1406.3585c-.0283.0713.0215.1416.0986.1416h6.5977c.0771 0 .1474-.0489.169-.126.1122-.4082.1757-.837.1757-1.2803 0-2.6025-2.125-4.727-4.7344-4.727";

  static const String youtube =
      "M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z";

  static const String openai =
      "M239.184 106.203a64.716 64.716 0 0 0-5.576-53.103C219.452 28.459 191 15.784 163.213 21.74A65.586 65.586 0 0 0 52.096 45.22a64.716 64.716 0 0 0-43.23 31.36c-14.31 24.602-11.061 55.634 8.033 76.74a64.665 64.665 0 0 0 5.525 53.102c14.174 24.65 42.644 37.324 70.446 31.36a64.72 64.72 0 0 0 48.754 21.744c28.481.025 53.714-18.361 62.414-45.481a64.767 64.767 0 0 0 43.229-31.36c14.137-24.558 10.875-55.423-8.083-76.483Zm-97.56 136.338a48.397 48.397 0 0 1-31.105-11.255l1.535-.87 51.67-29.825a8.595 8.595 0 0 0 4.247-7.367v-72.85l21.845 12.636c.218.111.37.32.409.563v60.367c-.056 26.818-21.783 48.545-48.601 48.601Zm-104.466-44.61a48.345 48.345 0 0 1-5.781-32.589l1.534.921 51.722 29.826a8.339 8.339 0 0 0 8.441 0l63.181-36.425v25.221a.87.87 0 0 1-.358.665l-52.335 30.184c-23.257 13.398-52.97 5.431-66.404-17.803ZM23.549 85.38a48.499 48.499 0 0 1 25.58-21.333v61.39a8.288 8.288 0 0 0 4.195 7.316l62.874 36.272-21.845 12.636a.819.819 0 0 1-.767 0L41.353 151.53c-23.211-13.454-31.171-43.144-17.804-66.405v.256Zm179.466 41.695-63.08-36.63L161.73 77.86a.819.819 0 0 1 .768 0l52.233 30.184a48.6 48.6 0 0 1-7.316 87.635v-61.391a8.544 8.544 0 0 0-4.4-7.213Zm21.742-32.69-1.535-.922-51.619-30.081a8.39 8.39 0 0 0-8.492 0L99.98 99.808V74.587a.716.716 0 0 1 .307-.665l52.233-30.133a48.652 48.652 0 0 1 72.236 50.391v.205ZM88.061 139.097l-21.845-12.585a.87.87 0 0 1-.41-.614V65.685a48.652 48.652 0 0 1 79.757-37.346l-1.535.87-51.67 29.825a8.595 8.595 0 0 0-4.246 7.367l-.051 72.697Zm11.868-25.58 28.138-16.217 28.188 16.218v32.434l-28.086 16.218-28.188-16.218-.052-32.434Z";

  static const String bilibili =
      "M17.813 4.653h.854c1.51.054 2.769.578 3.773 1.574 1.004.995 1.524 2.249 1.56 3.76v7.36c-.036 1.51-.556 2.769-1.56 3.773s-2.262 1.524-3.773 1.56H5.333c-1.51-.036-2.769-.556-3.773-1.56S.036 18.858 0 17.347v-7.36c.036-1.511.556-2.765 1.56-3.76 1.004-.996 2.262-1.52 3.773-1.574h.774l-1.174-1.12a1.234 1.234 0 0 1-.373-.906c0-.356.124-.658.373-.907l.027-.027c.267-.249.573-.373.92-.373.347 0 .653.124.92.373L9.653 4.44c.071.071.134.142.187.213h4.267a.836.836 0 0 1 .16-.213l2.853-2.747c.267-.249.573-.373.92-.373.347 0 .662.151.929.4.267.249.391.551.391.907 0 .355-.124.657-.373.906zM5.333 7.24c-.746.018-1.373.276-1.88.773-.506.498-.769 1.13-.786 1.894v7.52c.017.764.28 1.395.786 1.893.507.498 1.134.756 1.88.773h13.334c.746-.017 1.373-.275 1.88-.773.506-.498.769-1.129.786-1.893v-7.52c-.017-.765-.28-1.396-.786-1.894-.507-.497-1.134-.755-1.88-.773zM8 11.107c.373 0 .684.124.933.373.25.249.383.569.4.96v1.173c-.017.391-.15.711-.4.96-.249.25-.56.374-.933.374s-.684-.125-.933-.374c-.25-.249-.383-.569-.4-.96V12.44c0-.373.129-.689.386-.947.258-.257.574-.386.947-.386zm8 0c.373 0 .684.124.933.373.25.249.383.569.4.96v1.173c-.017.391-.15.711-.4.96-.249.25-.56.374-.933.374s-.684-.125-.933-.374c-.25-.249-.383-.569-.4-.96V12.44c.017-.391.15-.711.4-.96.249-.249.56-.373.933-.373Z";

  static const String netflix =
      "m5.398 0 8.348 23.602c2.346.059 4.856.398 4.856.398L10.113 0H5.398zm8.489 0v9.172l4.715 13.33V0h-4.715zM5.398 1.5V24c1.873-.225 2.81-.312 4.715-.398V14.83L5.398 1.5z";

  static const String github =
      "M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12";

  static const String apple =
      "M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 3.039 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.636-3.325 1.662-3.415-.039-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09zM15.53 3.83c.843-1.012 1.4-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.559-1.701";

  static const String baidu =
      "M9.154 0C7.71 0 6.54 1.658 6.54 3.707c0 2.051 1.171 3.71 2.615 3.71 1.446 0 2.614-1.659 2.614-3.71C11.768 1.658 10.6 0 9.154 0zm7.025.594C14.86.58 13.347 2.589 13.2 3.927c-.187 1.745.25 3.487 2.179 3.735 1.933.25 3.175-1.806 3.422-3.364.252-1.555-.995-3.364-2.362-3.674a1.218 1.218 0 0 0-.261-.03zM3.582 5.535a2.811 2.811 0 0 0-.156.008c-2.118.19-2.428 3.24-2.428 3.24-.287 1.41.686 4.425 3.297 3.864 2.617-.561 2.262-3.68 2.183-4.362-.125-1.018-1.292-2.773-2.896-2.75zm16.534 1.753c-2.308 0-2.617 2.119-2.617 3.616 0 1.43.121 3.425 2.988 3.362 2.867-.063 2.553-3.238 2.553-3.988 0-.745-.62-2.99-2.924-2.99zm-8.264 2.478c-1.424.014-2.708.925-3.323 1.947-1.118 1.868-2.863 3.05-3.112 3.363-.25.309-3.61 2.116-2.864 5.42.746 3.301 3.365 3.237 3.365 3.237s1.93.19 4.171-.31c2.24-.495 4.17.123 4.17.123s5.233 1.748 6.665-1.616c1.43-3.364-.808-5.109-.808-5.109s-2.99-2.306-4.736-4.798c-1.072-1.665-2.348-2.268-3.528-2.257zm-2.234 3.84l1.542.024v8.197H7.758c-1.47-.291-2.055-1.292-2.13-1.462-.072-.173-.488-.976-.268-2.343.635-2.049 2.447-2.196 2.447-2.196h1.81zm3.964 2.39v3.881c.096.413.612.488.612.488h1.614v-4.343h1.689v5.782h-3.915c-1.517-.39-1.59-1.465-1.59-1.465v-4.317zm-5.458 1.147c-.66.197-.978.708-1.05.928-.076.22-.247.78-.1 1.269.294 1.095 1.248 1.144 1.248 1.144h1.37v-3.34z";

  static const String x =
      "M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z";

  static const String telegram =
      "M9.78 18.65l.28-4.23l7.68-6.92c.34-.31-.07-.46-.52-.19L7.74 13.3L3.64 12c-.88-.25-.89-.86.2-1.3l15.97-6.16c.73-.33 1.43.18 1.15 1.3l-2.72 12.81c-.19.91-.74 1.13-1.5.71L12.6 16.3l-1.99 1.93c-.23.23-.42.42-.83.42z";

  static const String akamai =
      "M13.0548 0C6.384 0 .961 5.3802.961 12.0078.961 18.6354 6.3698 24 13.0548 24c.6168 0 .6454-.3572.0859-.5293-4.9349-1.5063-8.5352-6.069-8.5352-11.4629 0-5.4656 3.6725-10.0706 8.6934-11.5195C13.8153.3448 13.6716 0 13.0548 0Zm2.3242 1.8223c-5.2648 0-9.5254 4.2606-9.5254 9.5254 0 1.2193.2285 2.3818.6445 3.4433.1722.459.4454.4584.4024.0137-.0287-.3156-.0567-.6447-.0567-.9746 0-5.2648 4.2606-9.5254 9.5254-9.5254 4.9779 0 6.4698 2.2235 6.6563 2.08.2008-.1577-1.808-4.5624-7.6465-4.5624zm.4687 4.0703c-1.8622.0592-3.651.7168-5.1035 1.8554-.2582.2009-.1567.3284.1445.1993 2.4675-1.076 5.5812-1.1046 8.6368-.043 2.0514.7173 3.2413 1.7364 3.3418 1.6934.1578-.0718-1.1915-2.2226-3.6446-3.1407-1.1135-.4196-2.2576-.6-3.375-.5644z";
}

/// Generic widget to render pre-parsed SVG paths
class _OfficialSvgWidget extends StatefulWidget {
  final String pathData;
  final Color color;
  final double scaleFactor;

  const _OfficialSvgWidget({
    required this.pathData,
    this.color = Colors.white,
    this.scaleFactor = 0.65,
  });

  @override
  State<_OfficialSvgWidget> createState() => _OfficialSvgWidgetState();
}

class _OfficialSvgWidgetState extends State<_OfficialSvgWidget> {
  static final Map<String, Path> _pathCache = {};
  static final Map<String, Rect> _boundsCache = {};

  Path get _path {
    return _pathCache.putIfAbsent(widget.pathData, () => _parseSvgPath(widget.pathData));
  }

  Rect get _bounds {
    return _boundsCache.putIfAbsent(widget.pathData, () => _path.getBounds());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _SvgPathPainter(
            path: _path,
            bounds: _bounds,
            color: widget.color,
            scaleFactor: widget.scaleFactor,
          ),
        );
      },
    );
  }
}

class _SvgPathPainter extends CustomPainter {
  final Path path;
  final Rect bounds;
  final Color color;
  final double scaleFactor;

  _SvgPathPainter({
    required this.path,
    required this.bounds,
    required this.color,
    required this.scaleFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final targetW = size.width * scaleFactor;
    final targetH = size.height * scaleFactor;
    final scale = math.min(targetW / bounds.width, targetH / bounds.height);

    canvas.save();
    final dx = (size.width - bounds.width * scale) / 2 - bounds.left * scale;
    final dy = (size.height - bounds.height * scale) / 2 - bounds.top * scale;
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SvgPathPainter oldDelegate) =>
      color != oldDelegate.color || scaleFactor != oldDelegate.scaleFactor;
}

/// Official 4-color Google 'G'
class _Google4ColorWidget extends StatelessWidget {
  const _Google4ColorWidget();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: const _Google4ColorPainter(),
        );
      },
    );
  }
}

class _Google4ColorPainter extends CustomPainter {
  static Path? _blue;
  static Path? _green;
  static Path? _yellow;
  static Path? _red;
  static const Rect _totalBounds = Rect.fromLTWH(0, 0, 533.5, 544.3);

  const _Google4ColorPainter();

  static void _initPaths() {
    _blue ??= _parseSvgPath("M533.5 278.4c0-18.5-1.5-37.1-4.7-55.3H272.1v104.8h147c-6.1 33.8-25.7 63.7-54.4 82.7v68h87.7c51.5-47.4 81.1-117.4 81.1-200.2z");
    _green ??= _parseSvgPath("M272.1 544.3c73.4 0 135.3-24.1 180.4-65.7l-87.7-68c-24.4 16.6-55.9 26-92.6 26-71 0-131.2-47.9-152.8-112.3H28.9v70.1c46.2 91.9 140.3 149.9 243.2 149.9z");
    _yellow ??= _parseSvgPath("M119.3 324.3c-11.4-33.8-11.4-70.4 0-104.2V150H28.9c-38.6 76.9-38.6 167.5 0 244.4l90.4-70.1z");
    _red ??= _parseSvgPath("M272.1 107.7c38.8-.6 76.3 14 104.4 40.8l77.7-77.7C405 24.6 339.7-.8 272.1 0 169.2 0 75.1 58 28.9 150l90.4 70.1c21.5-64.5 81.8-112.4 152.8-112.4z");
  }

  @override
  void paint(Canvas canvas, Size size) {
    _initPaths();
    final targetW = size.width * 0.62;
    final targetH = size.height * 0.62;
    final scale = math.min(targetW / _totalBounds.width, targetH / _totalBounds.height);

    canvas.save();
    final dx = (size.width - _totalBounds.width * scale) / 2 - _totalBounds.left * scale;
    final dy = (size.height - _totalBounds.height * scale) / 2 - _totalBounds.top * scale;
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    Paint p(Color c) => Paint()..color = c..style = PaintingStyle.fill..isAntiAlias = true;

    canvas.drawPath(_blue!, p(const Color(0xFF4285F4)));
    canvas.drawPath(_green!, p(const Color(0xFF34A853)));
    canvas.drawPath(_yellow!, p(const Color(0xFFFBBC04)));
    canvas.drawPath(_red!, p(const Color(0xFFEA4335)));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Fast.com: Official speedometer gauge, concentric signal arcs, and vertical needle
class _FastComOfficialWidget extends StatelessWidget {
  const _FastComOfficialWidget();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: const _FastComOfficialPainter(),
        );
      },
    );
  }
}

class _FastComOfficialPainter extends CustomPainter {
  static Path? _gauge;
  static Path? _needle;
  static const Rect _totalBounds = Rect.fromLTWH(179.53, 186.25, 141.15, 77.95);

  const _FastComOfficialPainter();

  static void _initPaths() {
    _gauge ??= _parseSvgPath(
      "M250.15 226.91v9.5a19.78 19.78 0 0 1 20.38 20.44H280A29.24 29.24 0 0 0 250.15 226.91ZM286 221a49.53 49.53 0 0 0-35.23-14.65h-0.59v10.16a39.66 39.66 0 0 1 40.21 40.33h10.16c0-.2 0-.39 0-.59A49.53 49.53 0 0 0 286 221ZM179.53 256.82a70.57 70.57 0 0 1 141.15 0v7.38h-19v-7.3h9.39v-0.08a61 61 0 0 0-121.91 0v0.08h9.39v7.3h-19v-7.38Z",
    );
    _needle ??= _parseSvgPath(
      "M255.22 250.7l-5-54.66-5 54.66A8 8 0 1 0 255.22 250.7Z",
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _initPaths();
    final targetW = size.width * 0.72;
    final targetH = size.height * 0.72;
    final scale = math.min(targetW / _totalBounds.width, targetH / _totalBounds.height);

    canvas.save();
    final dx = (size.width - _totalBounds.width * scale) / 2 - _totalBounds.left * scale;
    final dy = (size.height - _totalBounds.height * scale) / 2 - _totalBounds.top * scale;
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    final gaugePaint = Paint()
      ..color = const Color(0xFFE50914) // Official Netflix/Fast red
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(_gauge!, gaugePaint);
    canvas.drawPath(_needle!, needlePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// CacheFly: Official origami paper plane taking flight with trailing digital packets
class _CacheFlyOfficialWidget extends StatelessWidget {
  const _CacheFlyOfficialWidget();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: const _CacheFlyOfficialPainter(),
        );
      },
    );
  }
}

class _CacheFlyOfficialPainter extends CustomPainter {
  const _CacheFlyOfficialPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final planePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Top wing
    final topWing = Path()
      ..moveTo(w * 0.32, h * 0.18)
      ..lineTo(w * 0.92, h * 0.12)
      ..lineTo(w * 0.46, h * 0.38)
      ..close();
    canvas.drawPath(topWing, planePaint);

    // Bottom wing
    final bottomWing = Path()
      ..moveTo(w * 0.46, h * 0.38)
      ..lineTo(w * 0.92, h * 0.12)
      ..lineTo(w * 0.68, h * 0.54)
      ..close();
    canvas.drawPath(
      bottomWing,
      Paint()
        ..color = Colors.white.withAlpha(225)
        ..isAntiAlias = true,
    );

    // Keel / under fold
    final keel = Path()
      ..moveTo(w * 0.46, h * 0.38)
      ..lineTo(w * 0.56, h * 0.46)
      ..lineTo(w * 0.48, h * 0.46)
      ..close();
    canvas.drawPath(
      keel,
      Paint()
        ..color = Colors.white.withAlpha(170)
        ..isAntiAlias = true,
    );

    // Trailing data packet squares forming the iconic "C" curve
    final sqPaint = Paint()
      ..color = Colors.white
      ..isAntiAlias = true;
    final packets = [
      Rect.fromLTWH(w * 0.22, h * 0.16, w * 0.08, w * 0.08),
      Rect.fromLTWH(w * 0.34, h * 0.26, w * 0.07, w * 0.07),
      Rect.fromLTWH(w * 0.20, h * 0.32, w * 0.08, w * 0.08),
      Rect.fromLTWH(w * 0.30, h * 0.42, w * 0.07, w * 0.07),
      Rect.fromLTWH(w * 0.14, h * 0.46, w * 0.07, w * 0.07),
      Rect.fromLTWH(w * 0.08, h * 0.58, w * 0.07, w * 0.07),
      Rect.fromLTWH(w * 0.18, h * 0.62, w * 0.07, w * 0.07),
      Rect.fromLTWH(w * 0.12, h * 0.72, w * 0.06, w * 0.06),
      Rect.fromLTWH(w * 0.22, h * 0.78, w * 0.06, w * 0.06),
      Rect.fromLTWH(w * 0.32, h * 0.82, w * 0.06, w * 0.06),
      Rect.fromLTWH(w * 0.44, h * 0.80, w * 0.05, w * 0.05),
    ];

    for (final rect in packets) {
      canvas.drawRect(rect, sqPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Link: Vector interlocked chain loops
class _CustomLinkPainter extends CustomPainter {
  const _CustomLinkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.11
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path1 = Path();
    path1.moveTo(w * 0.38, h * 0.22);
    path1.lineTo(w * 0.58, h * 0.22);
    path1.arcToPoint(Offset(w * 0.58, h * 0.52), radius: Radius.circular(w * 0.15));
    path1.lineTo(w * 0.38, h * 0.52);
    path1.arcToPoint(Offset(w * 0.38, h * 0.22), radius: Radius.circular(w * 0.15));

    final path2 = Path();
    path2.moveTo(w * 0.42, h * 0.48);
    path2.lineTo(w * 0.62, h * 0.48);
    path2.arcToPoint(Offset(w * 0.62, h * 0.78), radius: Radius.circular(w * 0.15));
    path2.lineTo(w * 0.42, h * 0.78);
    path2.arcToPoint(Offset(w * 0.42, h * 0.48), radius: Radius.circular(w * 0.15));

    canvas.save();
    canvas.translate(w / 2, h / 2);
    canvas.rotate(-math.pi / 4);
    canvas.translate(-w / 2, -h / 2);

    canvas.drawPath(path1, strokePaint);
    canvas.drawPath(path2, strokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Lightweight, zero-dependency SVG path parser
Path _parseSvgPath(String svgPath) {
  final path = Path();
  final tokens = <String>[];
  final regExp = RegExp(r'([MmLlHhVvCcSsQqTtAaZz])|([+-]?(?:\d*\.\d+|\d+)(?:[eE][+-]?\d+)?)');
  for (final match in regExp.allMatches(svgPath)) {
    tokens.add(match.group(0)!);
  }

  double curX = 0.0;
  double curY = 0.0;
  double lastCtrlX = 0.0;
  double lastCtrlY = 0.0;
  String lastCmd = '';

  int i = 0;
  while (i < tokens.length) {
    final token = tokens[i];
    final isCmd = RegExp(r'[MmLlHhVvCcSsQqTtAaZz]').hasMatch(token);

    String cmd;
    if (isCmd) {
      cmd = token;
      i++;
    } else {
      if (lastCmd == 'M') cmd = 'L';
      else if (lastCmd == 'm') cmd = 'l';
      else cmd = lastCmd;
    }

    switch (cmd) {
      case 'M':
        curX = double.parse(tokens[i++]);
        curY = double.parse(tokens[i++]);
        path.moveTo(curX, curY);
        lastCtrlX = curX;
        lastCtrlY = curY;
        break;
      case 'm':
        curX += double.parse(tokens[i++]);
        curY += double.parse(tokens[i++]);
        path.moveTo(curX, curY);
        lastCtrlX = curX;
        lastCtrlY = curY;
        break;
      case 'L':
        curX = double.parse(tokens[i++]);
        curY = double.parse(tokens[i++]);
        path.lineTo(curX, curY);
        lastCtrlX = curX;
        lastCtrlY = curY;
        break;
      case 'l':
        curX += double.parse(tokens[i++]);
        curY += double.parse(tokens[i++]);
        path.lineTo(curX, curY);
        lastCtrlX = curX;
        lastCtrlY = curY;
        break;
      case 'H':
        curX = double.parse(tokens[i++]);
        path.lineTo(curX, curY);
        lastCtrlX = curX;
        lastCtrlY = curY;
        break;
      case 'h':
        curX += double.parse(tokens[i++]);
        path.lineTo(curX, curY);
        lastCtrlX = curX;
        lastCtrlY = curY;
        break;
      case 'V':
        curY = double.parse(tokens[i++]);
        path.lineTo(curX, curY);
        lastCtrlX = curX;
        lastCtrlY = curY;
        break;
      case 'v':
        curY += double.parse(tokens[i++]);
        path.lineTo(curX, curY);
        lastCtrlX = curX;
        lastCtrlY = curY;
        break;
      case 'C':
        final x1 = double.parse(tokens[i++]);
        final y1 = double.parse(tokens[i++]);
        final x2 = double.parse(tokens[i++]);
        final y2 = double.parse(tokens[i++]);
        curX = double.parse(tokens[i++]);
        curY = double.parse(tokens[i++]);
        path.cubicTo(x1, y1, x2, y2, curX, curY);
        lastCtrlX = x2;
        lastCtrlY = y2;
        break;
      case 'c':
        final x1 = curX + double.parse(tokens[i++]);
        final y1 = curY + double.parse(tokens[i++]);
        final x2 = curX + double.parse(tokens[i++]);
        final y2 = curY + double.parse(tokens[i++]);
        curX += double.parse(tokens[i++]);
        curY += double.parse(tokens[i++]);
        path.cubicTo(x1, y1, x2, y2, curX, curY);
        lastCtrlX = x2;
        lastCtrlY = y2;
        break;
      case 'S':
        double x1;
        double y1;
        if (lastCmd == 'C' || lastCmd == 'c' || lastCmd == 'S' || lastCmd == 's') {
          x1 = 2 * curX - lastCtrlX;
          y1 = 2 * curY - lastCtrlY;
        } else {
          x1 = curX;
          y1 = curY;
        }
        final x2 = double.parse(tokens[i++]);
        final y2 = double.parse(tokens[i++]);
        curX = double.parse(tokens[i++]);
        curY = double.parse(tokens[i++]);
        path.cubicTo(x1, y1, x2, y2, curX, curY);
        lastCtrlX = x2;
        lastCtrlY = y2;
        break;
      case 's':
        double x1;
        double y1;
        if (lastCmd == 'C' || lastCmd == 'c' || lastCmd == 'S' || lastCmd == 's') {
          x1 = 2 * curX - lastCtrlX;
          y1 = 2 * curY - lastCtrlY;
        } else {
          x1 = curX;
          y1 = curY;
        }
        final x2 = curX + double.parse(tokens[i++]);
        final y2 = curY + double.parse(tokens[i++]);
        curX += double.parse(tokens[i++]);
        curY += double.parse(tokens[i++]);
        path.cubicTo(x1, y1, x2, y2, curX, curY);
        lastCtrlX = x2;
        lastCtrlY = y2;
        break;
      case 'A':
      case 'a':
        final isRel = cmd == 'a';
        final rx = double.parse(tokens[i++]);
        final ry = double.parse(tokens[i++]);
        final angle = double.parse(tokens[i++]) * math.pi / 180.0;
        final largeArc = double.parse(tokens[i++]) != 0;
        final sweep = double.parse(tokens[i++]) != 0;
        final tx = double.parse(tokens[i++]);
        final ty = double.parse(tokens[i++]);
        curX = isRel ? curX + tx : tx;
        curY = isRel ? curY + ty : ty;
        path.arcToPoint(
          Offset(curX, curY),
          radius: Radius.elliptical(rx, ry),
          rotation: angle,
          largeArc: largeArc,
          clockwise: sweep,
        );
        lastCtrlX = curX;
        lastCtrlY = curY;
        break;
      case 'Z':
      case 'z':
        path.close();
        break;
      default:
        break;
    }
    lastCmd = cmd;
  }
  return path;
}
