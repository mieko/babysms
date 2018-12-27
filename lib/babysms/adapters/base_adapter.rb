require 'active_model'
require 'active_model/validations'

module BabySMS
  module Adapters
    class BaseAdapter
      using ActiveModel::Validations
    end
  end
end
