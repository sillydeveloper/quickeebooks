require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Customer < Quickeebooks::Windows::Service::ServiceBase
        
        def create(customer)
          raise InvalidModelException unless customer.valid?
          xml = customer.to_xml_ns
          response = do_http_post(url_for_resource(Quickeebooks::Windows::Model::Customer.resource_for_singular), valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Windows::Model::Customer.from_xml(response.body)
          else
            nil
          end
        end

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          custom_field_query = '<?xml version="1.0" encoding="utf-8"?>'
          custom_field_query += '<CustomerQuery xmlns="http://www.intuit.com/sb/cdm/v2">'
          custom_field_query += "<StartPage>#{page}</StartPage><ChunkSize>#{per_page}</ChunkSize>"
          custom_field_query += '</CustomerQuery>'
          fetch_collection(Quickeebooks::Windows::Model::Customer, custom_field_query.strip, filters, page, per_page, sort, options)
        end
        
        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::Customer::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::Customer, url, {:idDomain => idDomain})
        end

      end
    end
  end
end