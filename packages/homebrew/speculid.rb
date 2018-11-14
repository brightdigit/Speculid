cask 'speculid' do
  version '2.0.0-alpha.3'
  sha256 'a42856845a422893e0493638c8ae8f6ea282b74a80075474f527836a4d5ae605'

  # github.com/brightdigit/Speculid was verified as official when first introduced to the cask
  url 'https://github.com/brightdigit/Speculid/releases/download/v2.0.0-alpha.3/Speculid.zip'
  appcast 'https://github.com/brightdigit/Speculid/releases.atom'
  name 'Speculid'
  homepage 'https://speculid.com/'

  app 'Speculid.App'
  binary "#{appdir}/Speculid.App/Contents/SharedSupport/speculid"
end
