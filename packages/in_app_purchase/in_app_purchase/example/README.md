# 인앱 결제 예제

인앱 결제(IAP) 플러그인을 사용하는 방법을 시연합니다.

## 시작하기

### 준비 작업

인앱 결제를 성공적으로 테스트하기 위해서는 상당한 설정 작업이 필요합니다. 여기에는 테스트에 사용할 새로운 앱 ID 등록과 Play Developer Console 및 App Store Connect에서 사용할 스토어 항목 등록이 포함됩니다.
Google Play와 App Store 모두 인앱 결제 API를 호출하려면 인앱 아이템을 구매할 수 있도록 앱을 구성해야 합니다.
두 스토어 모두 이 작업에 대한 광범위한 문서를 제공하며, 아래에 고수준 가이드를 포함시켰습니다.

- [인앱 구매 (App Store)](https://developer.apple.com/in-app-purchase/)
- [Google Play 결제 개요](https://developer.android.com/google/play/billing/billing_overview)

### Android

1. [Play Developer Console](https://play.google.com/apps/publish/) (PDC)에서 새로운 앱을 만듭니다.

2. PDC에서 상인 계정에 가입합니다.

3. PDC에서 앱에서 구매 가능한 IAP를 만듭니다.
   예제에서는 다음과 같은 SKU ID가 있다고 가정합니다:

   - `consumable`: 관리되는 제품.
   - `upgrade`: 관리되는 제품.
   - `subscription_silver`: 낮은 단계의 구독.
   - `subscription_gold`: 높은 단계의 구독.

   모든 제품이 `ACTIVE` 상태로 설정되었는지 확인하십시오.

4. `example/android/app/build.gradle`의 `APP_ID`를 PDC의 패키지 ID와 일치하도록 업데이트합니다.

5. 서명 정보를 모두 포함한 `example/android/keystore.properties` 파일을 만듭니다.
   `keystore.example.properties` 파일이 예시로 제공됩니다.
   서명되지 않은 APK에서는 `BillingClient` API를 사용할 수 없습니다.
   자세한 내용은 [여기](https://developer.android.com/studio/publish/app-signing#secure-shared-keystore)와 [여기](https://developer.android.com/studio/publish/app-signing#sign-apk)를 참조하세요.

6. 서명된 APK를 빌드합니다. `flutter build apk` 명령어를 사용하면 됩니다. 이 프로젝트의 gradle 파일은 디버그 빌드조차도 서명되도록 구성되어 있습니다.

7. 6단계에서 생성된 서명된 APK를 PDC에 업로드하고 알파 테스트 채널에 배포합니다.
   테스트 계정을 승인된 테스터로 추가하십시오.
   앱이 알파 채널에 완전히 배포되고 승인된 테스트 계정에서 사용되지 않으면 `BillingClient` API는 작동하지 않습니다.
   자세한 내용은 [여기](https://support.google.com/googleplay/android-developer/answer/3131213)를 참조하세요.

8. 7단계의 테스트 계정으로 테스트 장치에 로그인합니다.
   그런 다음 `flutter run`을 사용하여 앱을 장치에 설치하고 정상적으로 테스트하십시오.

### iOS

Xcode 12와 iOS 14 이상을 사용하는 경우 App Store Connect에서 앱을 구성하지 않아도 시뮬레이터나 장치에서 예제를 실행할 수 있습니다.
예제 앱은 `example/ios/Runner/Configuration.storekit` 파일에 구성된 StoreKit Testing을 사용하도록 설정되어 있습니다 (문서 [Xcode에서 StoreKit Testing 설정하기](https://developer.apple.com/documentation/xcode/setting_up_storekit_testing_in_xcode?language=objc) 참조).
애플리케이션을 실행하려면 다음 단계를 따르십시오 (Xcode에서 실행할 때만 작동합니다):

1. Xcode에서 예제 앱을 열고, `File > Open File`에서 `example/ios/Runner.xcworkspace`를 선택합니다.

2. Xcode에서 현재 스킴을 편집합니다, `Product > Scheme > Edit Scheme...` (또는 `Command + Shift + ,` 단축키).

3. StoreKit 테스트를 활성화합니다:
   a. `Run` 액션을 선택합니다;
   b. 액션 설정에서 `Options`를 클릭합니다;
   c. StoreKit 구성 옵션에서 `Configuration.storekit`을 선택합니다.

4. 스킴 편집기를 닫기 위해 `Close` 버튼을 클릭합니다;

5. 예제 앱을 실행할 장치를 선택합니다;

6. `Product > Run`을 사용하여 애플리케이션을 실행합니다 (또는 실행 버튼을 클릭).

iOS 14 이전 버전에서 테스트할 때는 시뮬레이터에서 예제 앱을 실행할 수 없으며, App Store Connect에서 앱을 구성해야 합니다.
아래 단계를 따라 구성할 수 있습니다:

1. ["인앱 구매 구성 워크플로"](https://help.apple.com/app-store-connect/#/devb57be10e7)를 따르십시오, 앱에서 IAP를 활성화하기 위해 필요한 모든 단계에 대한 상세 가이드입니다.
   1단계("유료 애플리케이션 계약 서명")와 2단계("인앱 구매 구성")를 완료하십시오.

   2단계 "App Store Connect에서 인앱 구매 구성"에서는 다음 제품을 생성합니다:

   - 제품 ID `consumable`의 소비성 제품
   - 제품 ID `upgrade`의 업그레이드
   - 제품 ID `subscription_silver`의 자동 갱신 구독
   - 제품 ID `subscription_gold`의 비갱신 구독

2. XCode에서 `File > Open File`을 선택하여 `example/ios/Runner.xcworkspace`를 엽니다.
   Bundle ID를 1단계에서 생성한 앱의 Bundle ID와 일치하도록 업데이트합니다.

3. 인앱 구매를 테스트하기 위해 [Sandbox 테스터 계정을 생성](https://help.apple.com/app-store-connect/#/dev8b997bee1)합니다.

4. `flutter run`을 사용하여 앱을 설치하고 테스트합니다.
   시뮬레이터 대신 실제 장치에서 테스트해야 합니다.
   그런 다음 예제 앱에서 제품 중 하나를 클릭하면 iOS 설정에서 "SANDBOX ACCOUNT" 섹션이 활성화됩니다.
   이제 구매를 완료하기 위해 sandbox 테스트 계정으로 로그인하라는 메시지가 표시됩니다(청구되지 않으므로 걱정하지 마십시오). 만약 로그인 요청이 나타나지 않거나 잘못된 사용자가 표시되는 경우, iOS 설정("설정" -> "App Store" -> "SANDBOX ACCOUNT")에서 sandbox 계정을 업데이트하십시오.
   이 절차는 [Sandbox로 인앱 구매 테스트하기](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox?language=objc) 문서에서 상세히 설명되어 있습니다.

**중요:** sandbox 테스트 계정을 사용해 프로덕션 서비스(iTunes 포함)에 로그인하면 계정이 영구적으로 무효화됩니다.
