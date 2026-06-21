import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 検索窓下エリアで表示する一覧の種別。
enum HomeTab { pinned, bookmarked }

class HomeTabController extends Notifier<HomeTab> {
  @override
  HomeTab build() => HomeTab.pinned;

  void select(HomeTab tab) {
    state = tab;
  }
}

final homeTabProvider = NotifierProvider<HomeTabController, HomeTab>(
  HomeTabController.new,
);

/// 検索窓下エリア（ピン留め/ブックマーク）の表示・非表示。初期状態は表示。
class HomeTabAreaVisibilityController extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() {
    state = !state;
  }
}

final homeTabAreaVisibleProvider =
    NotifierProvider<HomeTabAreaVisibilityController, bool>(
      HomeTabAreaVisibilityController.new,
    );
