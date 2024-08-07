require 'spec_helper'

module BerkeleyLibrary
  module DeoVolente
    describe File do
      describe :new do
        it 'instantiates a new instance' do
          f = File.new(filename: 'spec/data/foo.csv')
          expect(f.filename).to eq('foo.csv')
        end

        it 'throws an error if the filename does not exist'
      end

      describe :md5_hash do
        it 'calculates an MD5' do
          f = File.new(filename: 'spec/data/foo.csv')
          expect(f.md5_hash).to eq('11f8e9dc8c473278962dbadfd803e4c1')
        end
      end
    end
  end
end
