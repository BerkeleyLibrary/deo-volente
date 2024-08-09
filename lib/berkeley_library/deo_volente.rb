# frozen_string_literal: true

Dir.glob(File.expand_path('deo_volente/*.rb', __dir__)).each(&method(:require))

module BerkeleyLibrary
  # A set of helper tools for loading data into the UC Berkeley Dataverse
  module DeoVolente
  end
end
