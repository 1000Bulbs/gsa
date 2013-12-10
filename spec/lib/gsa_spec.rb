require 'spec_helper'

describe GSA do
  include Fixtures

  before(:each) do
    GSA.base_uri = gsa_base_uri
  end

  describe "#feed" do

    context "add" do

      context "many records" do

        it "successfully adds the records to the gsa index" do

          VCR.use_cassette("many_records") do
            results = GSA.feed(
              :records         => many_records, 
              :searchable      => [:name, :description], 
              :datasource_name => "products",
              :datasource_uri  => "http://0.0.0.0:3000/products",
              :datasource_uid  => "id"
            )
            results.should eq success_text
          end
        end
      end

      context "a single record" do

        it "successfully adds the records to the gsa index" do

          VCR.use_cassette("single_record") do
            results = GSA.feed(
              :records         => many_records, 
              :searchable      => [:name, :description], 
              :datasource_name => "products",
              :datasource_uri  => "http://0.0.0.0:3000/products",
              :datasource_uid  => "id"
            )
            results.should eq success_text
          end
        end
      end
    end

    context "delete" do

      context "many records" do

        it "successfully deletes the records from the gsa index" do

          VCR.use_cassette("delete_many_records") do
            results = GSA.feed(
              :records         => many_records, 
              :searchable      => [:name, :description], 
              :datasource_name => "products",
              :datasource_uri  => "http://0.0.0.0:3000/products",
              :datasource_uid  => "id",
              :delete?         => true
            )
            results.should eq success_text
          end
        end
      end

      context "a single record" do

        it "successfully deletes the record from the gsa index" do

          VCR.use_cassette("delete_single_record") do
            results = GSA.feed(
              :records         => one_records, 
              :searchable      => [:name, :description], 
              :datasource_name => "products",
              :datasource_uri  => "http://0.0.0.0:3000/products",
              :datasource_uid  => "id",
              :delete?         => true
            )
            results.should eq success_text
          end
        end
      end
    end

    context "without a base_uri set" do

      before(:each) do
        GSA.base_uri = nil
      end

      it "raises an error" do
        expect { 

          GSA.feed(
            :records         => one_records, 
            :searchable      => [:name, :description], 
            :datasource_name => "products",
            :datasource_uri  => "http://0.0.0.0:3000/products",
            :datasource_uid  => "id",
            :delete?         => true
          ) 
          
        }.to raise_error GSA::URINotSetError
      end
    end
  end

  describe "#search" do

    context "with no filters" do

      context "with a query yielding many matches" do

        let(:query)       { many_query }
        let(:results_set) { many_results }

        it "returns many records" do

          VCR.use_cassette("many_results_no_filters") do
            results = GSA.search(query)
            results.count.should eq results_set.count
          end
        end

        it "returns results in the expected 'pretty' format" do

          VCR.use_cassette("many_results_no_filters") do
            results = GSA.search(query)
            results.should eq results_set
          end
        end
      end

      context "with a query yielding a single match" do

        let(:query)      { one_query }
        let(:result_set) { one_results }

        it "returns a single record" do

          VCR.use_cassette("single_result_no_filters") do
            results = GSA.search(query)
            results[:result_sets].count.should eq 1
          end
        end

        it "returns the single result in the expected 'pretty' format" do

          VCR.use_cassette("single_result_no_filters") do
            results = GSA.search(query)
            results[:result_sets].should eq result_set[:result_sets]
          end
        end
      end

      context "with a query yielding no matches" do

        let(:query) { none_query }

        it "returns the no record flag" do

          VCR.use_cassette("no_result_no_filters") do
            results = GSA.search(query)
            results.should eq GSA::NO_RESULTS
          end
        end
      end
    end

    context "with filters" do

      context "with a query yielding many results" do

        let(:query)        { many_query }
        let(:results_set)  { many_results }
        let(:filter_name)  { "attribute_brand" }
        let(:filter_value) { "HLS" }
        let(:filters)      { "#{filter_name}:#{filter_value}" }

        it "returns less than the unfiltered results" do

          VCR.use_cassette("many_results_with_filters") do
            results = GSA.search(query, :filters => filters)
            results[:result_sets].count.should be < results_set[:result_sets].count
          end
        end

        it "should only contain results matched in the unfiltered results" do

          VCR.use_cassette("many_results_with_filters") do
            results = GSA.search(query, :filters => filters)

            filtered_results = []
            results_set[:result_sets].each {|result| 
              result[:metatags].each {|tag| 
                if tag[:meta_name] == filter_name && tag[:meta_value] == filter_value
                  filtered_results << result
                end
              }
            }

            result_uids   = GSA.uids(results[:result_sets], uid)
            filtered_uids = GSA.uids(filtered_results, uid)
            result_uids.should eq filtered_uids
          end
        end
      end

      context "with a query yielding a single result" do

        let(:query)          { many_query }
        let(:results_set)    { many_results }
        let(:filter_1_name)  { "attribute_color" }
        let(:filter_1_value) { "Red" }
        let(:filter_2_name)  { "attribute_brand" }
        let(:filter_2_value) { "Vickerman" }
        let(:filters)        { "#{filter_1_name}:#{filter_1_value}.#{filter_2_name}:#{filter_2_value}" }

        it "returns a single filtered result" do

          VCR.use_cassette("single_result_with_filters") do
            results = GSA.search(query, :filters => filters)
            results[:result_sets].count.should eq 1
          end
        end

        it "returns a result with the expected matching filters" do

          VCR.use_cassette("single_result_with_filters") do
            results = GSA.search(query, :filters => filters)

            results[:result_sets].each.inject([]) {|flags, result| result[:metatags].each {|tag|
                flags << 1 if tag[:meta_name] == filter_1_name && tag[:meta_value] == filter_1_value
                flags << 1 if tag[:meta_name] == filter_2_name && tag[:meta_value] == filter_2_value
              }
              flags
            }.should eq [1, 1]
          end
        end
      end

      context "with a query yielding no results" do

        let(:query)   { many_query }
        let(:filters) { "brand:FooBar" }

        it "returns the no record flag" do

          VCR.use_cassette("no_result_with_filters") do
            results = GSA.search(query, :filters => filters)
            results.should eq GSA::NO_RESULTS
          end
        end
      end

      context "without a base_uri set" do

        let(:query)   { many_query }
        let(:filters) { "brand:Philips" }

        before(:each) do
          GSA.base_uri = nil
        end

        it "raises an error" do

          expect { 

            GSA.search(query, :filters => filters) 

          }.to raise_error GSA::URINotSetError
        end
      end

      context "with the xml flag set to true" do

        let(:query) { one_query }
        let(:results_set) { one_results_xml }

        it "returns the raw xml from the search" do

          VCR.use_cassette('raw_xml_return') do

            results = GSA.search(query, {}, true)
            results.should == results_set
          end
        end

        context "with no result" do

          let(:query) { none_query }

          it "returns 0" do

            VCR.use_cassette('raw_xml_return_no_results') do

              results = GSA.search(query, {}, true)
              results.should == GSA::NO_RESULTS
            end
          end
        end
      end
    end
  end

  describe "#uids" do

    context "with multiple records passed in" do

      let(:results_set) { many_results }
      let(:uids)        { many_uids }

      it "returns multiple uids" do

        results = GSA.uids(results_set[:result_sets], uid)
        results.should eq uids
      end
    end

    context "with a single record passed in" do

      let(:results_set) { one_results }
      let(:uids)        { one_uids }

      it "returns a single uid" do

        results = GSA.uids(results_set[:result_sets], uid)
        results.should eq uids
      end
    end
  end
end
