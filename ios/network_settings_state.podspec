Pod::Spec.new do |s|
  s.name             = 'network_settings_state'
  s.version          = '0.1.6'
  s.summary          = 'Query whether Wi-Fi and mobile data are enabled in device settings.'
  s.description      = <<-DESC
Query whether Wi-Fi and mobile data are enabled in the device's system
settings, independent of which network is currently carrying traffic.
                       DESC
  s.homepage         = 'https://github.com/the-little-hackers/network_settings_state'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'The Little Hackers' => 'hello@thelittlehackers.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'network_settings_state/Sources/network_settings_state/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version    = '5.0'
end
