Pod::Spec.new do |s|
  s.name             = 'move_to_background'
  s.version          = '1.0.3'
  s.summary          = 'A flutter plugin for moving apps to the background'
  s.homepage         = 'https://github.com/aimy1/Wmimo'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Wmimo' => 'wmimo@app.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
