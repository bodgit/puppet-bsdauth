# @since 2.0.0
type BSDAuth::LDAP::Server = Struct[{NotUndef[hostname] => Bodgitlib::Host, Optional[port] => Bodgitlib::Port, Optional[mode] => Enum['plain', 'starttls', 'ssl'], Optional[version] => Integer[1, 3]}]
