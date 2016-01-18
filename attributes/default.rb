#
# Cookbook Name:: gem2rpm
# Attributes:: default
#
# Copyright 2013-2014, Thomas Boerger <thomas@webhippie.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default["gem2rpm"]["packages"] = value_for_platform_family(
  "debian" => %w(
  ),
  "suse" => [
    "ruby#{node["languages"]["ruby"]["version"].to_f}-rubygem-gem2rpm"
  ]
)

default["gem2rpm"]["gems"] = value_for_platform_family(
  "debian" => %w(
    gem2rpm
  ),
  "suse" => %w(
  )
)

case node["platform_family"]
when "suse"
  repo = case node["platform_version"]
  when /\A13\.\d+\z/
    "openSUSE_#{node["platform_version"]}"
  when /\A42\.\d+\z/
    "openSUSE_Leap_#{node["platform_version"]}"
  when /\A\d{8}\z/
    "openSUSE_Tumbleweed"
  else
    raise "Unsupported SUSE version"
  end

  default["gem2rpm"]["zypper"]["enabled"] = true
  default["gem2rpm"]["zypper"]["alias"] = "ruby"
  default["gem2rpm"]["zypper"]["title"] = "Ruby"
  default["gem2rpm"]["zypper"]["repo"] = "http://download.opensuse.org/repositories/devel:/languages:/ruby/#{repo}/"
  default["gem2rpm"]["zypper"]["key"] = "#{node["gem2rpm"]["zypper"]["repo"]}repodata/repomd.xml.key"
end
