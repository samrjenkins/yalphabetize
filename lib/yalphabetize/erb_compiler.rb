# frozen_string_literal: true

module Yalphabetize
  class ErbCompiler < ERB::Compiler
    def initialize(trim_mode)
      @new_array = []
      @tmp_array = []
      super
    end

    attr_reader :new_array

    def erb_interpolations
      new_array.map(&:join)
    end

    def compile_stag(stag, out, scanner)
      case stag
      when PercentLine
        add_put_cmd(out, content) if content.size > 0
        self.content = +''
        out.push(stag.to_s)
        out.cr
      when :cr
        out.cr
      when '<%', '<%=', '<%#'
        scanner.stag = stag
        add_put_cmd(out, content) if content.size > 0
        self.content = +''
        @tmp_array << stag
      when "\n"
        content << "\n"
        add_put_cmd(out, content)
        self.content = +''
      when '<%%'
        scanner.stag = stag
        content << '<%'
        @tmp_array << stag
      else
        content << stag
      end
    end

    def compile_etag(etag, out, scanner)
      case etag
      when '%>'
        compile_content(scanner.stag, out)
        scanner.stag = nil
        self.content = +''
        @new_array << (@tmp_array << etag)
        @tmp_array = []
      when '%%>'
        scanner.stag = nil
        content << '%>'
        @new_array << (@tmp_array << etag)
        @tmp_array = []
      else
        content << etag
        @tmp_array << etag
      end
    end

    def compile_content(stag, out)
      case stag
      when '<%'
        if content[-1] == ?\n
          content.chop!
          out.push(content)
          out.cr
        else
          out.push(content)
        end
      when '<%='
        add_insert_cmd(out, content)
      when '<%#'
        # commented out
      end
    end
  end
end
