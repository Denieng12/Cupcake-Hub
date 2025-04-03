import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';


class PlatformImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final String? heroTag;

  const PlatformImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.loadingWidget,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the URL for the specific platform
    final String formattedUrl;
    
    // Add parameters for width and height if needed
    if (imageUrl.contains('unsplash.com')) {
      final params = <String>[];
      
      if (width != null) params.add('w=${width!.toInt()}');
      if (height != null) params.add('h=${height!.toInt()}');
      if (kIsWeb) params.add('fit=crop');
      
      if (params.isNotEmpty) {
        if (imageUrl.contains('?')) {
          formattedUrl = '$imageUrl&${params.join('&')}';
        } else {
          formattedUrl = '$imageUrl?${params.join('&')}';
        }
      } else {
        formattedUrl = imageUrl;
      }
    } else {
      formattedUrl = imageUrl;
    }
    
    // Create the image widget based on the platform
    Widget imageWidget;
    
    if (kIsWeb) {
      // Web-specific image handling
      imageWidget = CachedNetworkImage(
        imageUrl: formattedUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => loadingWidget ?? _defaultLoadingWidget(),
        errorWidget: (context, url, error) => errorWidget ?? _defaultErrorWidget(),
      );
    } else if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      // Mobile-specific image handling with caching
      imageWidget = CachedNetworkImage(
        imageUrl: formattedUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => loadingWidget ?? _defaultLoadingWidget(),
        errorWidget: (context, url, error) => errorWidget ?? _defaultErrorWidget(),
      );
    } else {
      // Fallback for other platforms
      imageWidget = Image.network(
        formattedUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return loadingWidget ?? _defaultLoadingWidget();
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _defaultErrorWidget();
        },
      );
    }

    // Apply hero animation if hero tag is provided
    if (heroTag != null) {
      imageWidget = Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }

    // Apply border radius if provided
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _defaultLoadingWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}