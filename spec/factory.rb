module NOTAM
  class Factory
    class << self

      def head
        @head ||= {
          new: 'A0135/20 NOTAMN',
          replace: 'A0137/20 NOTAMR A0135/20',
          cancel: 'A0139/20 NOTAMC A0137/20'
        }
      end

      def q
        @q ||= {
          egtt: 'Q) EGTT/QMRXX/IV/NBO/A/000/999/5129N00028W005'
        }
      end

      def a
        @a ||= {
          egll: 'A) EGLL',
          lsas: 'A) LSAS LOVV LIMM'
        }
      end

      def b
        @b ||= {
          fix: 'B) 0208231540'
        }
      end

      def c
        @c ||= {
          fix: 'C) 0210310200',
          estimated: 'C) 0210310500 EST',
          spaceless: 'C) 0210041030EST',
          permanent: 'C) PERM'
        }
      end

      def d
        @d ||= {
        }
      end

      def e
        @e ||= {
        }
      end

      def f
        @f ||= {
        }
      end

      def g
        @g ||= {
        }
      end

      def sample_message
        %i(head q a b c d e f g).map { send(_1).values.sample }.join("\n")
      end

    end
  end
end
