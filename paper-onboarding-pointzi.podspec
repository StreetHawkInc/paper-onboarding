
Pod::Spec.new do |s|

  s.name         = "paper-onboarding-pointzi"
  s.version      = "1.1.4"
  s.summary      = "Amazing onboarding."
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/StreetHawkInc/paper-onboarding.git'
  s.author       = { 'StreetHawk' => 'support@streethawk.com' }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/StreetHawkInc/paper-onboarding.git', :tag => s.version.to_s }
  s.source_files  = 'Source/**/*.swift'
  end
