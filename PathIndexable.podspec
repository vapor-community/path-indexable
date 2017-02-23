Pod::Spec.new do |spec|
  spec.name         = 'PathIndexable'
  spec.version      = '2.0.0-alpha.1'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/vapor/path-indexable'
  spec.authors      = { 'Vapor' => 'contact@vapor.codes' }
  spec.summary      = 'A bite sized library for dealing with bytes.'
  spec.source       = { :git => "#{spec.homepage}.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.9"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/codevapor'
  spec.default_subspec = "Default"

  spec.subspec "Default" do |ss|
    ss.source_files = 'Sources/**/*.{swift}'
  end
end
