// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

export 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

/// Basic API for making in app purchases across multiple platforms.
class InAppPurchase implements InAppPurchasePlatformAdditionProvider {
  InAppPurchase._();

  static InAppPurchase? _instance;

  /// [InAppPurchase] 인스턴스를 사용하십시오.
  static InAppPurchase get instance {
    if (_instance != null) {
      return _instance!;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatform.registerPlatform();
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      InAppPurchaseStoreKitPlatform.registerPlatform();
    }

    _instance = InAppPurchase._();
    return _instance!;
  }

  @override
  T getPlatformAddition<T extends InAppPurchasePlatformAddition?>() {
    return InAppPurchasePlatformAddition.instance as T;
  }

  /// 이 방송 스트림을 청취하여 구매에 대한 실시간 업데이트를 받으십시오.
  ///
  /// 이 스트림은 앱이 활성 상태인 한 절대 닫히지 않습니다.
  ///
  /// 구매 업데이트는 여러 상황에서 발생할 수 있습니다:
  /// * 사용자가 앱 내에서 구매를 시작할 때.
  /// * 사용자가 플랫폼별 스토어 프론트에서 구매를 시작할 때.
  /// * 사용자가 앱에서 기기로 구매를 복원할 때.
  /// * 이전 앱 세션에서 구매가 완료되지 않은 경우([completePurchase]가 구매 객체에서 호출되지 않음).
  /// 구매 업데이트는 새 앱 세션이 시작될 때 대신 발생합니다.
  ///
  /// 중요! 앱이 시작되자마자 이 스트림을 구독해야 하며, 가능하면 main()에서 메인 앱 위젯을 반환하기 전에 구독하는 것이 좋습니다.
  /// 그렇지 않으면 이 스트림이 구독되기 전에 발생한 구매 업데이트를 놓칠 수 있습니다.
  ///
  /// 또한, 특정 시점에서 하나의 구독으로 스트림을 듣는 것을 권장합니다.
  /// 동시에 여러 구독을 선택할 경우, 각 구독이 시작된 이후 모든 이벤트를 수신하게 되므로 주의해야 합니다.
  Stream<List<PurchaseDetails>> get purchaseStream =>
      InAppPurchasePlatform.instance.purchaseStream;

  /// 결제 플랫폼이 준비되어 있고 사용 가능한 경우 `true`를 반환합니다.
  Future<bool> isAvailable() => InAppPurchasePlatform.instance.isAvailable();

  /// 주어진 ID 세트에 대한 제품 세부 정보를 쿼리합니다.
  ///
  /// 기본 결제 플랫폼의 식별자입니다. 예를 들어, iOS의 경우 [App Store Connect](https://appstoreconnect.apple.com/), Android의 경우 [Google Play Console](https://play.google.com/)이 있습니다.
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) =>
      InAppPurchasePlatform.instance.queryProductDetails(identifiers);

  /// 비소모성 제품 또는 구독을 구매하십시오.
  ///
  /// 비소모성 아이템은 한 번만 구매할 수 있습니다.
  /// 예를 들어, 앱에서 특별한 콘텐츠를 잠금 해제하는 구매가 이에 해당합니다.
  /// 구독도 비소모성 제품입니다.
  ///
  /// 사용자가 휴대폰을 변경할 때 항상 모든 비소모성 제품을 복원해야 합니다.
  ///
  /// 이 메서드는 구매 결과를 반환하지 않습니다.
  /// 대신, 이 메서드를 트리거한 후 [purchaseStream]으로 구매 업데이트가 전송됩니다.
  /// [purchaseStream]을 [Stream.listen]하여 [PurchaseDetails] 객체를 다양한 [PurchaseDetails.status]에서 수신하고 이에 따라 UI를 업데이트해야 합니다.
  /// [PurchaseDetails.status]가 [PurchaseStatus.purchased], [PurchaseStatus.restored] 또는 [PurchaseStatus.error]일 때 콘텐츠를 제공하거나 오류를 처리한 후 [completePurchase]를 호출하여 구매 프로세스를 완료해야 합니다.
  ///
  /// 이 메서드는 구매 요청이 초기적으로 성공적으로 전송되었는지 여부를 반환합니다.
  ///
  /// 소모성 아이템은 각 기본 결제 플랫폼에 따라 다르게 정의되며, 런타임에 [ProductDetail]이 소모성인지 여부를 쿼리할 수 있는 방법이 없습니다.
  ///
  /// 또한 참고할 사항:
  ///
  ///  * 소모성 제품 구매에 관한 [buyConsumable].
  ///  * 비소모성 제품 복원에 관한 [restorePurchases].
  ///
  /// 이 메서드를 소모성 아이템에 호출하면 원치 않는 동작이 발생할 수 있습니다!
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) =>
      InAppPurchasePlatform.instance.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

  /// 소모성 제품을 구매하십시오.
  ///
  /// 소모성 아이템은 사용되었다고 표시된 후 추가로 구매할 수 있습니다.
  /// 예를 들어, 체력 포션이 이에 해당합니다.
  ///
  /// 기기 간 소모성 구매를 복원하려면, 사용자의 소모성 구매 정보를 자체 서버에 기록하고 이를 복원해야 합니다.
  /// 소모된 제품은 더 이상 결제 플랫폼에서 "소유"로 간주되지 않으며 [restorePurchases]를 호출해도 제공되지 않습니다.
  ///
  /// 소모성 아이템은 각 기본 결제 플랫폼에 따라 다르게 정의되며, 런타임에 [ProductDetail]이 소모성인지 여부를 쿼리할 수 있는 방법이 없습니다.
  ///
  /// `autoConsume`은 유틸리티로 제공되며, 성공적인 구매 후 제품을 자동으로 소비하도록 플러그인에 지시합니다.
  /// `autoConsume`은 기본적으로 `true`로 설정되어 있습니다.
  ///
  /// 이 메서드는 구매 결과를 반환하지 않습니다.
  /// 대신, 이 메서드를 트리거한 후 [purchaseStream]으로 구매 업데이트가 전송됩니다.
  /// [purchaseStream]을 [Stream.listen]하여 [PurchaseDetails] 객체를 다양한 [PurchaseDetails.status]에서 수신하고 이에 따라 UI를 업데이트해야 합니다.
  /// [PurchaseDetails.status]가 [PurchaseStatus.purchased] 또는 [PurchaseStatus.error]일 때 콘텐츠를 제공하거나 오류를 처리한 후 [completePurchase]를 호출하여 구매 프로세스를 완료해야 합니다.
  ///
  /// 이 메서드는 구매 요청이 초기적으로 성공적으로 전송되었는지 여부를 반환합니다.
  ///
  /// 또한 참고할 사항:
  ///
  ///  * 비소모성 제품 또는 구독 구매에 관한 [buyNonConsumable].
  ///  * 비소모성 제품 복원에 관한 [restorePurchases].
  ///
  /// 이 메서드를 비소모성 아이템에 호출하면 원치 않는 동작이 발생할 수 있습니다!
  Future<bool> buyConsumable({
    required PurchaseParam purchaseParam,
    bool autoConsume = true,
  }) =>
      InAppPurchasePlatform.instance.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: autoConsume,
      );

  /// 구매한 콘텐츠가 사용자에게 전달되었음을 표시합니다.
  ///
  /// [PurchaseDetails.status]가 [PurchaseStatus.purchased] 또는 [PurchaseStatus.restored]인 모든 [PurchaseDetails]를 완료할 책임이 있습니다.
  /// [PurchaseStatus.pending] 구매를 완료하면 예외가 발생합니다.
  /// 편의를 위해 [PurchaseDetails.pendingCompletePurchase]는 구매가 완료 대기 중인지 여부를 나타냅니다.
  ///
  /// 이 메서드는 구매가 완료될 수 없을 때 [PurchaseException]을 던집니다.
  /// [PurchaseException.errorCode]에 따라 개발자는 이 메서드를 통해 구매를 다시 완료하거나, 나중에 [completePurchase] 메서드를 다시 시도해야 합니다.
  /// [PurchaseException.errorCode]가 다시 시도하지 말아야 한다고 표시할 경우, 앱의 코드 또는 해당 스토어의 구성에 문제가 있을 수 있습니다.
  /// 개발자는 이 문제를 해결할 책임이 있습니다.
  /// [PurchaseException.message] 필드는 문제가 무엇인지에 대한 추가 정보를 제공할 수 있습니다.
  Future<void> completePurchase(PurchaseDetails purchase) =>
      InAppPurchasePlatform.instance.completePurchase(purchase);

  /// 이전의 모든 구매를 복원합니다.
  ///
  /// `applicationUserName`은 초기 `PurchaseParam`에서 전송된 것과 일치해야 합니다.
  ///
  /// 만약 아무 것도 지정되지 않았다면 `null`을 사용하십시오.
  ///
  /// 복원된 구매는 [purchaseStream]을 통해 [PurchaseStatus.restored] 상태로 전달됩니다.
  /// 이러한 구매를 수신하고, 영수증을 확인하며, 콘텐츠를 전달하고 각 구매에 대해 [completePurchase] 메서드를 호출하여 구매를 완료해야 합니다.
  ///
  /// 이 메서드는 소모된 제품을 반환하지 않습니다.
  /// 사용자의 소모되지 않은 소모성 제품을 복원하려면, 자체 서버에 소모성 제품 정보를 기록해 두어야 합니다.
  ///
  /// 또한 참고할 사항:
  ///
  ///  * 실패한 [PurchaseDetails.verificationData]를 다시 로드하기 위한 [InAppPurchasePlatform.instance.refreshPurchaseVerificationData].
  Future<void> restorePurchases({String? applicationUserName}) =>
      InAppPurchasePlatform.instance.restorePurchases(
        applicationUserName: applicationUserName,
      );

  /// 사용자의 국가를 반환합니다.
  ///
  /// 안드로이드:
  /// ISO-3166-1 alpha2 형식에 따라 Play 결제 국가 코드를 반환합니다.
  ///
  /// 참고: https://developer.android.com/reference/com/android/billingclient/api/BillingConfig
  /// 참고: https://unicode.org/cldr/charts/latest/supplemental/territory_containment_un_m_49.html
  ///
  /// iOS:
  /// SKStoreFrontWrapper에서 국가 코드를 반환합니다.
  ///
  /// 참고: https://developer.apple.com/documentation/storekit/skstorefront?language=objc
  ///
  ///
  Future<String> countryCode() => InAppPurchasePlatform.instance.countryCode();
}
