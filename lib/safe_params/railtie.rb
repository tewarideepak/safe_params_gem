require 'rails/railtie'

module SafeParams
  class Railtie < Rails::Railtie
    initializer 'safe_params.helper' do
      ActiveSupport.on_load(:action_controller) do
        include SafeParams::Helper
      end
    end
  end
end
