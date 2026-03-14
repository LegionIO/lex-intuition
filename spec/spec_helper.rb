# frozen_string_literal: true

require 'legion/extensions/intuition/version'
require 'legion/extensions/intuition/helpers/constants'
require 'legion/extensions/intuition/helpers/pattern'
require 'legion/extensions/intuition/helpers/heuristic'
require 'legion/extensions/intuition/helpers/intuition_engine'
require 'legion/extensions/intuition/runners/intuition'
require 'legion/extensions/intuition/client'

module Legion
  module Extensions
    module Helpers
      module Lex; end
    end
  end
end

module Legion
  module Logging
    def self.method_missing(*); end
    def self.respond_to_missing?(*) = true
  end
end
