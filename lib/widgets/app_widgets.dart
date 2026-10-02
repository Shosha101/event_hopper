import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:event_hopper/models/event_model.dart';
import 'package:event_hopper/providers/event_provider.dart';
import 'package:event_hopper/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Switches between Arabic and English; the label names the other language.
class LanguagePill extends StatelessWidget {
  const LanguagePill({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Material(
      color: AppColors.surface,
      shape: const StadiumBorder(side: BorderSide(color: AppColors.border)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => context.setLocale(Locale(isArabic ? 'en' : 'ar')),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 16, color: AppColors.muted),
              const SizedBox(width: 6),
              Text(
                context.tr('other_language'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Page heading for the tab screens: title, optional subtitle and the language switch.
class ScreenHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showLanguagePill;

  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showLanguagePill = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 14, color: AppColors.muted),
                ),
              ],
            ],
          ),
        ),
        if (showLanguagePill) ...[
          const SizedBox(width: 12),
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: LanguagePill(),
          ),
        ],
      ],
    );
  }
}

/// White card with the standard border and radius.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.surface,
    this.borderColor = AppColors.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

/// Centered icon, title and optional body and action: empty states.
class StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 34),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          if (body != null) ...[
            const SizedBox(height: 6),
            Text(
              body!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColors.muted,
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Round white button that sits on top of a photo or the map.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color color;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color = AppColors.text,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        elevation: 2,
        shadowColor: Colors.black38,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }
}

/// Heart that saves an event to favorites or removes it.
class FavoriteButton extends StatelessWidget {
  final EventModel event;
  const FavoriteButton({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<EventProvider>().isFavorite(event);
    return CircleIconButton(
      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
      color: isFavorite ? AppColors.accent : AppColors.text,
      tooltip: context.tr(isFavorite ? 'remove_favorite' : 'add_favorite'),
      onPressed: () => context.read<EventProvider>().toggleFavorite(event),
    );
  }
}

/// Event photo from the bundled assets, decoded near the size it is shown.
class EventImage extends StatelessWidget {
  final String imagePath;
  final double borderRadius;

  const EventImage({super.key, required this.imagePath, this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final pixelRatio = MediaQuery.devicePixelRatioOf(context);
          final longestSide = constraints.biggest.longestSide;
          return Image.asset(
            imagePath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            // Headroom over the box size, because the photo is cropped to cover it
            cacheWidth: longestSide.isFinite
                ? (longestSide * pixelRatio * 1.5).round()
                : null,
            errorBuilder: (context, error, stackTrace) => const ColoredBox(
              color: AppColors.primarySoft,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Text that comes from the event data: read in its own direction, aligned with the screen.
class ContentText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;

  const ContentText(this.text, {super.key, this.style, this.maxLines});

  @override
  Widget build(BuildContext context) {
    final isScreenRtl = Directionality.of(context) == TextDirection.rtl;
    return Text(
      text,
      textDirection: Bidi.detectRtlDirectionality(text)
          ? TextDirection.rtl
          : TextDirection.ltr,
      textAlign: isScreenRtl ? TextAlign.right : TextAlign.left,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: style,
    );
  }
}

/// Small accent icon followed by one line of muted text: the date and place lines.
class IconLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconLine({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 6),
        Expanded(
          child: ContentText(
            text,
            maxLines: 1,
            style: const TextStyle(fontSize: 13.5, color: AppColors.muted),
          ),
        ),
      ],
    );
  }
}

/// Event date and time in the current language, e.g. "Mon, Dec 30, 2024 · 10:00 AM".
String formatEventDateTime(BuildContext context, DateTime dateTime) {
  final locale = context.locale.languageCode;
  return context.tr(
    'date_time_format',
    args: [
      DateFormat.yMMMEd(locale).format(dateTime),
      DateFormat.jm(locale).format(dateTime),
    ],
  );
}

/// City and country of an event joined with the current language's comma.
String formatEventPlace(BuildContext context, EventModel event) {
  return context.tr('place_format', args: [event.city, event.country]);
}
