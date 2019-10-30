class JavascriptController < ApplicationController
    def dynamic_locations
        @location = location.find(:all)
    end
end
