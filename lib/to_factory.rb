require "fileutils"

require "to_factory/version"
require "to_factory/config"
require "to_factory/generation/factory"
require "to_factory/generation/attribute"
require "to_factory/collation"
require "to_factory/file_writer"
require "to_factory/finders/model"
require "to_factory/finders/factory"
require "to_factory/file_sync"
require "to_factory/parsing/file"
require "to_factory/representation"
require "to_factory/klass_inference"
require "to_factory/options_parser"
require "factory_bot"

module ToFactory
  class MissingActiveRecordInstanceException < Exception; end
  class NotFoundError < Exception; end

  class << self
    def definition_for(item)
      if item.is_a? ActiveRecord::Base
        Representation.from(item).definition
      else
        if found = representations.find { |r| r.name.to_s == item.to_s }
          found.definition
        else
          fail NotFoundError.new "No definition found for #{item}"
        end
      end
    end

    def definitions
      representations.map(&:name)
    end

    def representations
      Finders::Factory.new.call
    end
  end
end

public

def ToFactory(args = nil)
  exclusions = if args.is_a?(Hash)
                 exclusions = Array(args.delete(:exclude) || [])
                 args = nil if args.keys.length == 0
                 exclusions
               else
                 []
               end

  meth = ToFactory::FileSync.method(:new)
  sync = args ? meth.call(args) : meth.call

  sync.perform(exclusions)
end
