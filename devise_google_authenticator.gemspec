$LOAD_PATH.unshift File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name = "devise_google_authenticator"
  s.version = "0.3.17"
  s.authors = ["Christian Frichot"]
  s.date = "2015-02-08"
  s.description = "Devise Google Authenticator Extension, for adding Google's OTP to your Rails apps!"
  s.email = "xntrik@gmail.com"
  s.extra_rdoc_files = %w(LICENSE.txt README.rdoc)
  s.files = Dir["{app,config,lib}/**/*"] + %w[LICENSE.txt README.rdoc]
  s.homepage = "http://github.com/AsteriskLabs/devise_google_authenticator"
  s.licenses = %w(MIT)
  s.require_paths = %w(lib)
  s.summary = "Devise Google Authenticator Extension"

  s.add_runtime_dependency 'devise', '~> 4'
  s.add_runtime_dependency 'rotp', '~> 3.3.1'
  s.add_runtime_dependency 'rqrcode', '~> 0.10.1'
end
