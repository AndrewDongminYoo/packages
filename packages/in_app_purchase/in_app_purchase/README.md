Flutter 앱에서 스토어에 독립적인 API로 구매를 처리하기 위한 플러그인입니다.

<!-- 이 패키지가 별도의 저장소에 있다면, 여기 배지를 넣을 것입니다 -->

이 플러그인은 iOS와 macOS에서는 App Store, Android에서는 Google Play와 같은 *기본 스토어*를 통해 인앱 구매(_IAP_)를 지원합니다.

|          | Android | iOS   | macOS  |
| -------- | ------- | ----- | ------ |
| **지원** | SDK 16+ | 12.0+ | 10.15+ |

<p>
  <img src="https://github.com/flutter/packages/blob/main/packages/in_app_purchase/in_app_purchase/doc/iap_ios.gif?raw=true"
    alt="iOS 인앱 구매 UI의 애니메이션 이미지" height="400"/>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/flutter/packages/blob/main/packages/in_app_purchase/in_app_purchase/doc/iap_android.gif?raw=true"
   alt="Android 인앱 구매 UI의 애니메이션 이미지" height="400"/>
</p>

## 기능

Flutter 앱에서 이 플러그인을 사용하여 다음 작업을 수행할 수 있습니다:

- 기본 스토어에서 판매 가능한 인앱 제품을 표시합니다.
  제품에는 소모품, 영구 업그레이드 및 구독이 포함될 수 있습니다.
- 사용자가 소유한 인앱 제품을 로드합니다.
- 사용자를 기본 스토어로 보내 제품을 구매합니다.
- 구독 코드 사용을 위한 UI를 표시합니다. (iOS 14 전용)

## 시작하기

이 플러그인은 인앱 구매를 위해 App Store와 Google Play에 의존합니다. 통합된 인터페이스를 제공하지만, 여전히 각 스토어에 대해 앱을 이해하고 구성해야 합니다. 두 스토어 모두 광범위한 가이드를 제공합니다:

- [App Store 문서](https://developer.apple.com/in-app-purchase/)
- [Google Play 문서](https://developer.android.com/google/play/billing/billing_overview)

> 참고: 이 문서의 나머지 부분에서 App Store와 Google Play는 "스토어" 또는 "기본 스토어"로 지칭되며, 특정 스토어에만 해당하는 기능인 경우를 제외하고 사용됩니다.

두 스토어에서 인앱 구매를 구성하는 단계 목록은 [예제 앱 README](https://github.com/flutter/packages/blob/main/packages/in_app_purchase/in_app_purchase/example/README.md)를 참조하십시오.

각 스토어에서 인앱 구매를 설정한 후 플러그인을 사용할 수 있습니다. 기본적으로 두 가지 옵션이 있습니다:

1. 일반적인 Flutter API: [in_app_purchase](https://pub.dev/documentation/in_app_purchase/latest/in_app_purchase/in_app_purchase-library.html).
   이 API는 구매 로드 및 구매를 위한 대부분의 사용 사례를 지원합니다.

2. 플랫폼별 Dart API: [store_kit_wrappers](https://pub.dev/documentation/in_app_purchase_storekit/latest/store_kit_wrappers/store_kit_wrappers-library.html)와 [billing_client_wrappers](https://pub.dev/documentation/in_app_purchase_android/latest/billing_client_wrappers/billing_client_wrappers-library.html).
   이러한 API는 플랫폼별 동작을 노출하며, 필요한 경우 더 세밀한 제어를 가능하게 합니다. 그러나 이러한 API 중 하나를 사용하는 경우, 각 스토어프론트에 대해 구매 처리 로직이 상당히 달라집니다.

Flutter 앱에 인앱 구매 지원을 추가하는 방법에 대한 자세한 가이드는 [Flutter 인앱 구매 코드랩](https://codelabs.developers.google.com/codelabs/flutter-in-app-purchases)을 참조하십시오.

## 사용법

이 섹션에는 다음 작업을 위한 코드 예제가 포함되어 있습니다:

- [구매 업데이트 듣기](#구매-업데이트-듣기)
- [기본 스토어에 연결하기](#기본-스토어에-연결하기)
- [판매할 제품 로드하기](#판매할-제품-로드하기)
- [이전 구매 복원하기](#이전-구매-복원하기)
- [제품 구매하기](#제품-구매하기)
- [구매 완료하기](#구매-완료하기)
- [기존 인앱 구독 업그레이드 또는 다운그레이드하기](#기존-인앱-구독-업그레이드-또는-다운그레이드하기)
- [플랫폼별 제품 또는 구매 속성에 접근하기](#플랫폼별-제품-또는-구매-속성에-접근하기)
- [코드 사용 시트 표시하기 (iOS 14)](#코드-사용-시트-표시하기-ios-14)

**참고:** 자신의 앱의 `android/app/build.gradle` 파일에서 `com.android.billingclient:billing`을 의존성으로 추가할 필요는 없습니다. 이를 선택할 경우 충돌이 발생할 수 있습니다.

### 구매 업데이트 듣기

앱의 `initState` 메서드에서 모든 수신 구매에 대해 구독합니다. 이러한 구매는 기본 스토어 중 하나에서 전파될 수 있습니다.
모든 구매 업데이트를 포착할 수 있도록 가능한 한 빨리 구매 업데이트 듣기를 시작해야 합니다. 여기에는 이전 앱 세션의 구매도 포함됩니다.
업데이트를 듣기 위해 다음을 수행하십시오:

```dart
class _MyAppState extends State<MyApp> {
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    final Stream purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // 오류 처리.
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
```

다음은 구매 업데이트를 처리하는 방법의 예입니다:

```dart
void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      _showPendingUI();
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        _handleError(purchaseDetails.error!);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          _deliverProduct(purchaseDetails);
        } else {
          _handleInvalidPurchase(purchaseDetails);
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance
            .completePurchase(purchaseDetails);
      }
    }
  });
}
```

### 기본 스토어에 연결하기

```dart
final bool available = await InAppPurchase.instance.isAvailable();
if (!available) {
  // 스토어에 접근할 수 없습니다. UI를 이에 맞게 업데이트합니다.
}
```

### 판매할 제품 로드하기

```dart
// 세트 리터럴은 Dart 2.2에서 필요합니다. 대안으로,
// `Set<String> _kIds = <String>['product1', 'product2'].toSet()`을 사용할 수 있습니다.
const Set<String> _kIds = <String>{'product1', 'product2'};
final ProductDetailsResponse response =
    await InAppPurchase.instance.queryProductDetails(_kIds);
if (response.notFoundIDs.isNotEmpty) {
  // 오류 처리.
}
List<ProductDetails> products = response.productDetails;
```

### 이전 구매 복원하기

복원된 구매는 `InAppPurchase.purchaseStream`에서 방출되며, 각 기본 스토어에 대한 최선의 관행에 따라 복원된 구매를 검증해야 합니다:

- [App Store 구매 검증](https://developer.apple.com/documentation/storekit/in-app_purchase/validating_receipts_with_the_app_store)
- [Google Play 구매 검증](https://developer.android.com/google/play/billing/security#verify)

```dart
await InAppPurchase.instance.restorePurchases();
```

App Store에는 소모품 제품을 쿼리할 수 있는 API가 없으며, Google Play는 소모품 제품이 소비된 것으로 표시되면 더 이상 소유하지 않는다고 간주하며 여기에 반환하지 않습니다. 이러한 제품을 기기 간에 복원하려면 자신의 서버에 저장하고 해당 서버에 쿼리해야 합니다.

### 제품 구매하기

두 기본 스토어는 소모품 및 비소모품 제품을 다르게 처리합니다. `InAppPurchase`를 사용하는 경우, 이 점을 구분하여 각 유형에 대해 올바른 구매 메서드를 호출해야 합니다.

```dart
final ProductDetails productDetails = ... // queryProductDetails()에서 미리 저장된 것.
final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
if (_isConsumable(productDetails)) {
  InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
} else {
  InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
}
// 여기서부터 구매 흐름은 기본 스토어에 의해 처리됩니다.
// 업데이트는 `InAppPurchase.instance.purchaseStream`에 전달됩니다.
```

### 구매 완료하기

`InAppPurchase.purchaseStream`은 `InAppPurchase.buyConsumable` 또는 `InAppPurchase.buyNonConsumable`을 사용하여 구매 흐름을 시작한 후 구매 업데이트를 전송합니다. 구매 영수증을 검증하고 사용자가 콘텐츠를 전달받은 후에는 `InAppPurchase.completePurchase`를 호출하여 구매가 완료되었음을 기본 스토어에 알려주는 것이 중요합니다. `InAppPurchase.completePurchase`를 호출하면 앱이 구매를 검증하고 처리했으며 스토어는 트랜잭션을 완료하고 최종 사용자의 결제 계정을 청구할 수 있음을 기본 스토어에 알립니다.

> **경고:** 구매 후 3일 이내에 `InAppPurchase.completePurchase`를 호출하지 않거나 성공적인 응답을 받지 못하면 환불이 발생합니다.

### 기존 인앱 구독 업그레이드 또는 다운그레이드하기

Google Play에서 기존 인앱 구독을 업그레이드/다운그레이드하려면 사용자가 이동해야 하는 이전 `PurchaseDetails` 인스턴스와 함께 `ChangeSubscriptionParam`을 제공하고, `InAppPurchase.buyNonConsumable`을 호출할 때 `GooglePlayPurchaseParam` 객체에 선택적으로 `ProrationMode`를 제공합니다.

App Store에서는 구독 그룹화 메커니즘을 제공하므로 이 작업이 필요하지 않습니다. 제공하는 각 구독은 구독 그룹에 할당되어야 합니다. 관련된 구독을 그룹으로 묶으면 사용자가 실수로 여러 구독을 구매하는 것을 방지하는 데 도움이 됩니다. [Apple의 구독 가이드](https://developer.apple.com/app-store/subscriptions/)의 [구독 그룹 만들기](https://developer.apple.com/app-store/subscriptions/#groups) 섹션을 참조하십시오.

```dart
final PurchaseDetails oldPurchaseDetails = ...;
PurchaseParam purchaseParam = GooglePlayPurchaseParam(
    productDetails: productDetails,
    changeSubscriptionParam: ChangeSubscriptionParam(
        oldPurchaseDetails: oldPurchaseDetails,
        prorationMode: ProrationMode.immediateWithTimeProration));
InAppPurchase.instance
    .buyNonConsumable(purchaseParam: purchaseParam);
```

### 구독 가격 변경 확인

구독 가격이 변경되면 소비자는 해당 가격 변경을 확인해야 합니다. 소비자가 가격 변경을 확인하지 않으면 구독이 자동 갱신되지 않습니다. 기본적으로 iOS와 Android 모두에서 가격 변경 확인을 위한 팝업이 자동으로 표시됩니다. 플랫폼에 따라 이 흐름과 상호 작용하는 방법이 다르며, 다음 문단에서 설명합니다.

#### Google Play Store (Android)

기존 구독 기본 요금제 또는 제안의 가격을 변경할 때 기존 구독자는 레거시 가격 코호트에 배치됩니다. 앱 개발자는 [레거시 가격 코호트를 종료](https://developer.android.com/google/play/billing/price-changes#end-legacy)하고 구독자를 현재 기본 요금제 가격으로 이동하도록 선택할 수 있습니다. 새로운 구독 기본 요금제 가격이 낮을 때, Google은 이메일 및 알림을 통해 소비자에게 알립니다. 소비자는 다음 결제 시 낮은 가격을 지불하게 됩니다. 구독 가격이 인상되면, Google은 레거시 가격 코호트 종료 후 7일 후에 이메일 및 알림을 통해 자동으로 소비자에게 알리기 시작합니다. 가격 변경에 대해 소비자에게 사전 알림을 제공하고 가격 변경을 검토할 수 있도록 Play Store 구독 화면에 대한 딥 링크를 제공하는 것이 좋습니다. 공식 문서는 [여기](https://developer.android.com/google/play/billing/price-changes)에서 찾을 수 있습니다.

#### Apple App Store (iOS)

구독 가격이 인상되면 iOS에서도 앱 내에서 팝업을 표시합니다. StoreKit 결제 대기열은 앱에 가격 변경 확인 팝업을 표시하려고 한다고 알립니다. 기본적으로 대기열은 계속 진행할 수 있는 응답을 받고 팝업을 표시합니다. 그러나 'InAppPurchaseStoreKitPlatformAddition'을 통해 이 팝업을 방지하고 예를 들어 버튼을 클릭한 후 다른 시간에 팝업을 표시할 수 있습니다.

App Store에서 팝업을 표시하려고 할 때 이를 방지하려면 대기열 대리자를 등록할 수 있습니다. `InAppPurchaseStoreKitPlatformAddition`에는 대리자를 설정하거나 `null`로 설정하여 제거할 수 있는 `setDelegate(SKPaymentQueueDelegateWrapper? delegate)` 함수가 포함되어 있습니다.

```dart
// InAppPurchaseStoreKitPlatformAddition 가져오기
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

Future<void> initStoreInfo() async {
  if (Platform.isIOS) {
    var iosPlatformAddition = _inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
  }
}

@override
Future<void> disposeStore() {
  if (Platform.isIOS) {
    var iosPlatformAddition = _inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    await iosPlatformAddition.setDelegate(null);
  }
}
```

설정된 대리자는 `SKPaymentQueueDelegateWrapper`를 구현하고 `shouldContinueTransaction` 및 `shouldShowPriceConsent`를 처리해야 합니다. `shouldShowPriceConsent`를 false로 설정하면 기본 팝업이 표시되지 않으며 앱은 나중에 이를 표시해야 합니다.

```dart
// SKPaymentQueueDelegateWrapper 가져오기
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
```

`InAppPurchaseStoreKitPlatformAddition`에서 `showPriceConsentIfNeeded`를 호출하여 대화 상자를 표시할 수 있습니다. 이 미래는 대화 상자가 표시되면 즉시 완료됩니다. 확인된 트랜잭션은 `purchaseStream`에 전달됩니다.

```dart
if (Platform.isIOS) {
  var iapStoreKitPlatformAddition = _inAppPurchase
      .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
  await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
}
```

### 플랫폼별 제품 또는 구매 속성에 접근하기

함수 `_inAppPurchase.queryProductDetails(productIds);`는 `List<ProductDetails>` 유형의 구매 가능한 제품 목록과 함께 `ProductDetailsResponse`를 제공합니다. 이 `ProductDetails` 클래스는 모든 지원되는 플랫폼에서 사용 가능한 속성만 포함하는 플랫폼 독립적인 클래스입니다. 그러나 일부 경우에는 플랫폼별 속성에 접근해야 합니다. `ProductDetails` 인스턴스는 플랫폼이 Android일 때 `GooglePlayProductDetails`의 하위 유형이며, iOS에서는 `AppStoreProductDetails`입니다. skuDetails(Android의 경우) 또는 skProduct(iOS의 경우)에 접근하여 원래 플랫폼 객체에서 사용 가능한 모든 정보를 제공합니다.

다음은 Android에서 `introductoryPricePeriod`를 얻는 예제입니다:

```dart
// GooglePlayProductDetails 가져오기
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// SkuDetailsWrapper 가져오기
import 'package:in_app_purchase_android/billing_client_wrappers.dart';

if (productDetails is GooglePlayProductDetails) {
  SkuDetailsWrapper skuDetails = (productDetails as GooglePlayProductDetails).skuDetails;
  print(skuDetails.introductoryPricePeriod);
}
```

다음은 iOS에서 구독의 `subscriptionGroupIdentifier`를 얻는 방법입니다:

```dart
// AppStoreProductDetails 가져오기
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// SKProductWrapper 가져오기
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

if (productDetails is AppStoreProductDetails) {
  SKProductWrapper skProduct = (productDetails as AppStoreProductDetails).skProduct;
  print(skProduct.subscriptionGroupIdentifier);
}
```

`purchaseStream`은 `PurchaseDetails` 유형의 객체를 제공합니다. `PurchaseDetails`는 purchaseID와 transactionDate와 같은 모든 지원되는 플랫폼에서 사용 가능한 모든 정보를 제공합니다. 또한 플랫폼별 속성에 접근할 수 있습니다. `PurchaseDetails` 객체는 Android의 경우 `GooglePlayPurchaseDetails`, iOS의 경우 `AppStorePurchaseDetails`의 하위 유형입니다. billingClientPurchase 또는 skPaymentTransaction에 접근하여 원래 플랫폼 객체에서 사용 가능한 모든 정보를 제공합니다.

다음은 Android에서 `originalJson`을 얻는 예제입니다:

```dart
// GooglePlayPurchaseDetails 가져오기
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// PurchaseWrapper 가져오기
import 'package:in_app_purchase_android/billing_client_wrappers.dart';

if (purchaseDetails is GooglePlayPurchaseDetails) {
  PurchaseWrapper billingClientPurchase = (purchaseDetails as GooglePlayPurchaseDetails).billingClientPurchase;
  print(billingClientPurchase.originalJson);
}
```

iOS에서 구매의 `transactionState`를 얻는 방법:

```dart
// AppStorePurchaseDetails 가져오기
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// SKProductWrapper 가져오기
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

if (purchaseDetails is AppStorePurchaseDetails) {
  SKPaymentTransactionWrapper skProduct = (purchaseDetails as AppStorePurchaseDetails).skPaymentTransaction;
  print(skProduct.transactionState);
}
```

`in_app_purchase_android` 및/또는 `in_app_purchase_storekit`을 가져와야 한다는 점에 유의하십시오.

### 코드 사용 시트 표시하기 (iOS 14)

다음 코드는 사용자가 App Store Connect에서 설정한 프로모션 코드(offer codes)를 사용할 수 있는 시트를 표시합니다. 프로모션 코드 사용에 대한 자세한 내용은 [앱에서 프로모션 코드 구현](https://developer.apple.com/documentation/storekit/in-app_purchase/subscriptions_and_offers/implementing_offer_codes_in_your_app)을 참조하십시오.

```dart
InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
  InAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
iosPlatformAddition.presentCodeRedemptionSheet();
```

> **참고:** `InAppPurchaseStoreKitPlatformAddition`은 `in_app_purchase_storekit.dart` 파일에 정의되어 있으므로, `InAppPurchaseStoreKitPlatformAddition`을 사용할 파일에 이를 가져와야 합니다:
>
> ```dart
> import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
> ```

## 이 플러그인에 기여하기

이 플러그인에 기여하고자 한다면, [기여 가이드](https://github.com/flutter/packages/blob/main/CONTRIBUTING.md)를 확인하십시오.
