angular.module( 'ngbpMobileAngularUi', [
  'templates-app',
  'templates-common',
  'ngbpMobileAngularUi.home',
  'ngbpMobileAngularUi.about',
  'mobile-angular-ui',
  'ngTouch',
  'ngCookies',
  'pascalprecht.translate',
  'ui.router'
])

.config( function myAppConfig ( $stateProvider, $urlRouterProvider ) {
  $urlRouterProvider.otherwise( '/home' );
})

.run( function run () {
})

.controller( 'AppCtrl', function AppCtrl ( $scope, $location ) {
  // User agent displayed in home page
  $scope.userAgent = navigator.userAgent;
  
  // Needed for the loading screen
    $scope.$on('$viewContentLoading', function(event, viewConfig){ 
        // Access to all the view config properties.
        // and one special property 'targetView'
        // viewConfig.targetView 
        $scope.loading = true;
    });
    $scope.$on('$viewContentLoaded', function(event, viewConfig){ 
        // Access to all the view config properties.
        // and one special property 'targetView'
        // viewConfig.targetView 
        $scope.loading = false;
    });
  
  // Fake text i used here and there.
  $scope.lorem = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Vel explicabo, aliquid eaque soluta nihil eligendi adipisci error, illum corrupti nam fuga omnis quod quaerat mollitia expedita impedit dolores ipsam. Obcaecati.';

  
  
  $scope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams){
    if ( angular.isDefined( toState.data.pageTitle ) ) {
      $scope.pageTitle = toState.data.pageTitle + ' | ngBoilerplate' ;
    }
  });
  
  
  // 
  // Right Sidebar
  // 
  $scope.chatUsers = [
    { name: 'Carlos  Flowers', online: true },
    { name: 'Byron Taylor', online: true },
    { name: 'Jana  Terry', online: true },
    { name: 'Darryl  Stone', online: true },
    { name: 'Fannie  Carlson', online: true },
    { name: 'Holly Nguyen', online: true },
    { name: 'Bill  Chavez', online: true },
    { name: 'Veronica  Maxwell', online: true },
    { name: 'Jessica Webster', online: true },
    { name: 'Jackie  Barton', online: true },
    { name: 'Crystal Drake', online: false },
    { name: 'Milton  Dean', online: false },
    { name: 'Joann Johnston', online: false },
    { name: 'Cora  Vaughn', online: false },
    { name: 'Nina  Briggs', online: false },
    { name: 'Casey Turner', online: false },
    { name: 'Jimmie  Wilson', online: false },
    { name: 'Nathaniel Steele', online: false },
    { name: 'Aubrey  Cole', online: false },
    { name: 'Donnie  Summers', online: false },
    { name: 'Kate  Myers', online: false },
    { name: 'Priscilla Hawkins', online: false },
    { name: 'Joe Barker', online: false },
    { name: 'Lee Norman', online: false },
    { name: 'Ebony Rice', online: false }
  ];

  //
  // 'Forms' screen
  //  
  $scope.rememberMe = true;
  $scope.email = 'me@example.com';
  
  $scope.login = function() {
    alert('You submitted the login form');
  };

})

.config(function($translateProvider, $translatePartialLoaderProvider) {

    $translatePartialLoaderProvider.addPart('home');

    $translateProvider.useLoader('$translatePartialLoader', {
        urlTemplate: 'locales/{lang}/{part}.json'
    })
    .registerAvailableLanguageKeys(['en', "et"], {
    'en_US': 'en',
    'en_UK': 'en',
    'et_EE': 'ee'
    })
    .fallbackLanguage('en')
    .determinePreferredLanguage()
    .useLocalStorage();
})

;

