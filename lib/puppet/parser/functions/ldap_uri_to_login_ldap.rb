#
# ldap_uri_to_login_ldap.rb
#
require 'uri'

module Puppet::Parser::Functions
  newfunction(:ldap_uri_to_login_ldap, :type => :rvalue, :doc => <<-EOS
Transforms a single or array of LDAP URI strings into a form suitable for
passing as arguments to a class in login.conf(5) for use with login_(-)ldap.

The second argument dictates if any ldap:/// URI should attempt STARTTLS.
Currently all servers are assumed to support LDAPv3. The port is added if it
differs from the default port for the given scheme.

*Example:*

    ldap_uri_to_login_ldap('ldap://192.0.2.1', true)
    ldap_uri_to_login_ldap(['ldap://192.0.2.1', 'ldaps://192.0.2.2'], false)

Would result in:

    ['x-ldap-server=192.0.2.1,,starttls']
    ['x-ldap-server=192.0.2.1,,plain', 'x-ldap-serveralt0=192.0.2.2,,ssl']
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, 'ldap_uri_to_login_ldap(): Wrong number of ' +
      "arguments given (#{arguments.size}) for 2)") if arguments.size != 2

    servers  = arguments[0]
    starttls = arguments[1]

    unless servers.is_a?(Array) || servers.is_a?(String)
      raise(Puppet::ParseError, 'ldap_uri_to_login_ldap(): Requires either ' +
        'array or string to work with')
    end

    if servers.is_a?(String)
      servers = [servers]
    end

    return servers.collect.with_index do |x,i|
      v = case i
        when 0
          'x-ldap-server'
        else
          "x-ldap-serveralt#{i-1}"
        end

      begin
        u = URI(x)
        raise unless ['ldap', 'ldaps'].include?(u.scheme)
      rescue
        raise(Puppet::ParseError, 'ldap_uri_to_login_ldap(): Requires either ' +
            'ldap:/// or ldaps:/// URI to work with')
      end

      p = u.port.eql?(u.default_port) ? '' : u.port.to_s
      s = u.scheme.eql?('ldaps') ? 'ssl' : starttls ? 'starttls' : 'plain'

      "#{v}=#{u.host},#{p},#{s}"
    end
  end
end

# vim: set ts=2 sw=2 et :
