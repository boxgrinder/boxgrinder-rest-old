# JBoss, Home of Professional Open Source
# Copyright 2009, Red Hat Middleware LLC, and individual contributors
# by the @authors tag. See the copyright.txt in the distribution for a
# full listing of individual contributors.
#
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of
# the License, or (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this software; if not, write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301 USA, or see the FSF site: http://www.fsf.org.

require 'boxgrinder-core/helpers/appliance-helper'
require 'boxgrinder-core/validators/appliance-config-validator'

module AppliancesHelper
  include BaseHelper

  def validate_appliance_definition_file
    logger.debug "Reading appliance definition file..."

    definition_file = params[:definition]

    if definition_file.nil?
      render_error( Error.new( "No definition parameter specified in your request." ) )
      return
    end

    begin
      appliance_configs, appliance_config = BoxGrinder::ApplianceHelper.new( :log => logger ).read_definitions( definition_file.tempfile.path, definition_file.content_type )
      appliance_config_helper = BoxGrinder::ApplianceConfigHelper.new( appliance_configs )

      @appliance_config = appliance_config_helper.merge(appliance_config.clone)
    rescue => e
      render_error( Error.new( "Could not read definition file", e) )
      return
    end

    BoxGrinder::ApplianceConfigValidator.new( @appliance_config ).validate

    logger.debug "Appliance definition file is valid."
  end

  def is_appliance_status?( status )
    return false if @appliance.status.nil?
    @appliance.status.eql?( Appliance::STATUSES[status] )
  end

end
