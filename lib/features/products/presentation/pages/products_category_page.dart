import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../widgets/category_cell.dart';

class ProductsCategoryPage extends StatefulWidget {
  const ProductsCategoryPage({super.key});

  @override
  State<ProductsCategoryPage> createState() => _ProductsCategoryPageState();
}

class _ProductsCategoryPageState extends State<ProductsCategoryPage> {
  final List<CategoryLabel> categories = [
    CategoryLabel(title: 'لابتوبات', img: 'assets/img/p1.png', count: '6'),
    CategoryLabel(
      title: 'بطاريات',
      img: 'assets/img/batterylabel.png',
      count: '15',
    ),
    CategoryLabel(
      title: 'ألواح شمسية',
      img: 'assets/img/solarlabel.png',
      count: '15',
    ),
    CategoryLabel(
      title: 'أكبال',
      img: 'assets/img/cablelabel.png',
      count: '15',
    ),
    CategoryLabel(
      title: 'إكسسوارات',
      img: 'assets/img/accessorieslabel.png',
      count: '15',
    ),
    CategoryLabel(
      title: 'غير ذلك',
      img: 'assets/img/accessorieslabel.png',
      count: '15',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.surface,
      body: SafeArea(
        child: FadeInUp(
          delay: Duration(milliseconds: 300),
          child: CustomScrollView(
            slivers: [
              //Banner
              SliverAppBar(
                automaticallyImplyLeading: false,
                stretch: true,
                expandedHeight: 200.h,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: ZoomIn(
                    delay: Duration(microseconds: 350),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        // horizontal: 15.r,
                        // vertical: 10.r,
                      ),
                      child: Image.asset(
                        'assets/img/products_banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              //Products Grid
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 20.r),
                sliver: SliverGrid.builder(
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.h,
                    crossAxisSpacing: 15.w,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return CategoryCell(
                      onTap: () {
                        context.pushNamed(
                          'productsPage',
                          extra: categories[index].title,
                        );
                      },
                      category: categories[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryLabel {
  final String title;
  final String count;
  final String img;

  CategoryLabel({required this.title, required this.count, required this.img});
}
