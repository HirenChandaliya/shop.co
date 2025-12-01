import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHelper extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerHelper.rect({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  const ShimmerHelper.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}

// --- 1. PRODUCT CARD SHIMMER ---
class ProductShimmerGrid extends StatelessWidget {
  final int itemCount;

  const ProductShimmerGrid({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        childAspectRatio: 0.65,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (ctx, i) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Expanded(
            child: ShimmerHelper.rect(
              height: 200,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Title Placeholder
          const ShimmerHelper.rect(height: 15, width: 150),
          const SizedBox(height: 5),
          // Rating Placeholder
          const ShimmerHelper.rect(height: 10, width: 80),
          const SizedBox(height: 5),
          // Price Placeholder
          const ShimmerHelper.rect(height: 20, width: 60),
        ],
      ),
    );
  }
}

// --- 2. CATEGORY SHIMMER ---
class CategoryShimmerList extends StatelessWidget {
  const CategoryShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: List.generate(4, (index) {
        return ShimmerHelper.rect(
          width: 250,
          height: 180,
          shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
