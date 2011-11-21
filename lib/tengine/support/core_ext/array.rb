# -*- coding: utf-8 -*-

# このファイルはクラスやモジュールを定義せず、tengine/support/core_ext/*.rbをrequireするだけです
Dir.chdir(File.expand_path("../../../", File.dirname(__FILE__))) do
  Dir['tengine/support/core_ext/array'].each do |f|
    require File.basename(f)
  end
end
