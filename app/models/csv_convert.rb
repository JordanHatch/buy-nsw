module CsvConvert
  def CsvConvert.import
    filename_sellers = 'exported_sellers.csv'
    filename_products = 'exported_products.csv'
    puts "Reading in #{filename_sellers} and #{filename_products}..."
    table = CSV.read(filename_sellers, headers: true)
    table.each do |row|
      atts = {}
      row.each do |k, v|
        s = k.split('.')
        if s[0] == 'seller'
          atts[s[1]] = v
        end
      end
      # Parse industry specially
      # Note we're using eval WHICH IS USUALLY A VERY BAD THING
      # but in this case the csv data will never be edited by
      # anyone in the outside world
      atts['industry'] = eval(atts['industry'])
      atts['services'] = eval(atts['services'])

      seller = Seller.find_by(id: atts['id'])
      if seller
        seller.update_attributes(atts)
      else
        Seller.create!(atts)
      end
      # Now do the addresses
      number_of_addresses =
        row.select{|k,v| k.split('.')[0] == 'seller_address'}.map{|k,v| k.split('.')[1].to_i}.max
      (1..number_of_addresses).each do |i|
        atts = {}
        row.each do |k, v|
          s = k.split('.')
          if s[0] == 'seller_address' && s[1] == i.to_s
            atts[s[2]] = v
          end
        end
        address = SellerAddress.find_by(id: atts['id'])
        if address
          address.update_attributes(atts)
        else
          SellerAddress.create!(atts)
        end
      end
    end
    table = CSV.read(filename_products, headers: true)
    table.each do |row|
      atts = {}
      row.each do |k, v|
        s = k.split('.')
        if s[0] == 'product'
          atts[s[1]] = v
        end
      end
      atts['audiences'] = eval(atts['audiences'])
      atts['pricing_variables'] = eval(atts['pricing_variables'])
      atts['government_network_type'] = eval(atts['government_network_type'])
      atts['supported_browsers'] = eval(atts['supported_browsers'])
      atts['supported_os'] = eval(atts['supported_os'])
      atts['support_options'] = eval(atts['support_options'])
      atts['data_import_formats'] = eval(atts['data_import_formats'])
      atts['data_export_formats'] = eval(atts['data_export_formats'])
      atts['encryption_transit_user_types'] = eval(atts['encryption_transit_user_types'])
      atts['encryption_transit_network_types'] = eval(atts['encryption_transit_network_types'])
      atts['encryption_rest_types'] = eval(atts['encryption_rest_types'])
      atts['authentication_types'] = eval(atts['authentication_types'])
      atts['outage_channel_types'] = eval(atts['outage_channel_types'])
      atts['metrics_channel_types'] = eval(atts['metrics_channel_types'])
      atts['usage_channel_types'] = eval(atts['usage_channel_types'])

      product = Product.find_by(id: atts['id'])
      if product
        product.update_attributes(atts)
      else
        Product.create!(atts)
      end
    end
  end

  def CsvConvert.export
    filename_sellers = 'exported_sellers.csv'
    filename_products = 'exported_products.csv'
    puts "Writing exported sellers to #{filename_sellers}..."
    CSV.open(filename_sellers, 'w') do |csv|
      headers = Seller.new.attributes.keys.map{|key| "seller.#{key}"}
      # Figure out the maximum number of addresses that any seller has
      max_addresses = SellerAddress.group(:seller_id).count.values.max
      (1..max_addresses).each do |i|
        # TODO: Don't output seller_id attribute
        headers += SellerAddress.new.attributes.keys.map{|key| "seller_address.#{i}.#{key}"}
      end
      csv << headers
      Seller.find_each do |seller|
        # TODO: Convert arrays to something more easy to read/write
        values = seller.attributes.values
        seller.addresses.each do |address|
          # TODO: Don't output seller_id attribute
          values += address.attributes.values
        end
        csv << values
      end
    end
    puts "Writing exported products to #{filename_products}..."
    CSV.open(filename_products, 'w') do |csv|
      headers = Product.new.attributes.keys.map{|key| "product.#{key}"}
      csv << headers
      Product.find_each do |product|
        values = product.attributes.values
        csv << values
      end
    end
  end
end
