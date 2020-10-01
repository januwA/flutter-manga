import 'package:flutter/material.dart';
import 'package:flutter_imagenetwork/flutter_imagenetwork.dart';

AjanuwImage netImage(String url) {
  return AjanuwImage(
    image: AjanuwNetworkImage(url),
    fit: BoxFit.cover,
    loadingWidget: AjanuwImage.defaultLoadingWidget,
    loadingBuilder: AjanuwImage.defaultLoadingBuilder,
    errorBuilder: AjanuwImage.defaultErrorBuilder,
  );
}
