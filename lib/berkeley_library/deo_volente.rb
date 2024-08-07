# frozen_string_literal: true

Dir.glob(File.expand_path('deo_volente/*.rb', __dir__)).sort.each(&method(:require))
