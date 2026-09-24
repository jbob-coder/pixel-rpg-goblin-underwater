# Hunt-01 Encounter Trigger Runtime

Purpose: bridge completed Region-01 tracking into the first same-location tactical encounter without implementing attack resolution.

Owner boundary:
- tracking runtime owns `OBSERVATION_READY`;
- this package owns observation/engagement zones, explicit engagement authority, encounter staging, same-location actor continuity, first-person entry and tactical-node activation;
- combat packages own later action economy, attacks, reactions, damage, statuses and outcomes.

First-slice identities:
- encounter `enc_r01_ef02_m01_0001`;
- footprint `R01_EF02`;
- Monster `monster_r01_m01_0001`;
- source sector `R01_S03`;
- entry node `R01_EF02_N01`.

Current laws:
- clue completion alone never auto-starts combat;
- the Hunter must physically reach the Meadow observation/engagement area;
- ENGAGE is explicit;
- staging preserves the Hunter and Monster world transforms;
- staging uses the existing aerial/first-person production camera path;
- tactical nodes remain hidden until staging succeeds;
- no attack, damage, defeat or escape resolution is implemented here.

Phone/user acceptance is deferred-batch. Automated verification still gates each committed layer.
