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

    def compile(s)
      enc = s.encoding
      raise ArgumentError, "#{enc} is not ASCII compatible" if enc.dummy?
      s = s.b # see String#b
      magic_comment = detect_magic_comment(s, enc)
      out = Buffer.new(self, *magic_comment)

      self.content = +''
      scanner = make_scanner(s)
      scanner.instance_variable_set(:@stags, scanner.stags + ['%{'])
      scanner.instance_variable_set(:@etags, scanner.etags + ['}'])
      scanner.scan do |token|
        next if token.nil?
        next if token == ''
        if scanner.stag.nil?
          compile_stag(token, out, scanner)
        else
          compile_etag(token, out, scanner)
        end
      end
      add_put_cmd(out, content) if content.size > 0
      out.close
      return out.script, *magic_comment
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
      when '<%', '<%=', '<%#', '%{'
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
      when '%>', '}'
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
  end
end
