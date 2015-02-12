#!/bin/bash
text2wfreq < CRO | wfreq2vocab > CRO.vocab
text2idngram -vocab CRO.vocab -idngram CRO.idngram < CRO
idngram2lm -vocab_type 0 -idngram CRO.idngram -vocab CRO.vocab -arpa CRO.arpa
sphinx_lm_convert -i CRO.arpa -o CRO.lm.DMP
