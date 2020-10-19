require 'csl/style'

class BIB_Helpers < Middleman::Extension
	def initialize(app, options_hash={}, &block)
		super
		@@b=BibTeX.open('ict4g.bib').convert(:latex)
		@@c=CiteProc::Processor.new style: 'apa', format: 'text'
		@@c.import @@b.to_citeproc			
	end


	helpers do
		def bib_data()
			return  @@b.to_hash(:quotes => '')[:bibliography]
		end
		def bib(key)
			@@b[key].delete(:"date-added")
			@@b[key].delete(:"date-modified")
			@@b[key].delete(:"bdsk-file-1")
			@@b[key].delete(:"bdsk-url-1")
			@@b[key].delete(:"month_numeric")
			@@b[key].delete(:"ee")
			@@b[key].delete(:"crossref")
			return  @@b[key].to_s
		end
		def bib_entry(key)
			entry = @@c.render :bibliography, id: key
			return entry[0]
		end
		def search(key)
			b=bib_data()
		    for i in 0...b.length 
		    	if b[i][:bibtex_key] == key 
		      		return  b[i]
		    	end
		    end
		end
	end
end	
::Middleman::Extensions.register(:bib_helpers, BIB_Helpers) 
