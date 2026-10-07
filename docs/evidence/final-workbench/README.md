# Genuine local Workbench evidence — 2026-10-07

Captured directly from the running MySQL Workbench UI through native computer-use screenshots. These are not rendered CLI tables. Server: isolated local MySQL 8.4.11 on 127.0.0.1:33317. The six query captures were refreshed after the final verifier rebuild. Query 6 EXPLAIN was captured after ANALYZE TABLE returned OK for its four underlying tables; matching CLI output is preserved.

T01–T11 and the physical-address rejection were genuinely executed; error screenshots show expected rejection, and the verifier independently checks exact expected error messages. The verifier rebuild afterward removes test setup rows from the frozen dataset.

Official v4 workbook SHA: 88362589a519b6f9aeae031fe806bcf85f0d8b513c12b11f6a4e619ee855c4ac. E01 counts, E02 IDs, E03 wine/address encoding, E04 exact copy, E05 whitespace, E06 ambiguous pairs, E07 mixed statuses, E08 address duplicate groups, E09 shared phone groups, E10 staging accounting. Queries are in tools/final_v4_evidence_queries.sql. Public projections contain aggregates/source identifiers, not raw contact values. No raw workbook, CSV or INSERT data is published.

15 rows in seven non-exact repeated order/product pairs remain held. 166 other rows are candidates, not accepted production imports. Alias mapping, tutor/business disposition, genuine student contributions, video and RiPPlE activities remain human-only inputs. Students must review the captures and recapture if the course requires evidence under their own account.

## Screenshot SHA-256 manifest

| Capture | SHA-256 |
|---|---|
| additional_postalshipment.png | 8cd73215975e6c3634c43b327d7ab6ccfc98de97c3f9be9c344bd7fdf78b3152 |
| query01.png | b28a11a76372623efeef85ed4afb55e8d6664437093870429eb690e9d3839421 |
| query02.png | 8d87443a944c458fbef35bf0b6212348e474e5f376cddfb90d70df8a56fddfaf |
| query03.png | 0b8341ed68a57c9c4d2d5408a1a5651e6d46942fca4eccd6a95a51e30889ce64 |
| query04-left.png | b13cf667fab4a7748f8f3ed1f98471df617c0e374301f636c22d2507e6210ee5 |
| query05-30days.png | 88fe36a8784127a7569c4a33670eabb01f9675ca5fc77b05ec77c45e700c7f10 |
| query05-90days.png | 5e2cdc8db41bd23722aae849f70ed1de22c754150ea2e14b010a4796261779e2 |
| query06-explain-left.png | 399d7bc4e595a8c930dcd835b10988f74debd891540d0c4cbeb09d8ab8f5a6ee |
| query06-explain-right.png | 3b8e2d7f98f39b7360e426540deef770acaaefb76a8bbf0c1897f2fe6c75fa59 |
| query06-results-right.png | d2891ee7d609aa957f554d4b186d19e59d1f7cbf750db2f7a9b35ba95f0a8a44 |
| query06-results.png | 04500add4c43eb3237ee069eea454412fd343cda3d4b55f34ccd4c322675cd84 |
| t01_validtraining.png | 738b620c885433a1f685b58f4bfcc4ec56351f3e7a8847d2cbefcfd0253d84ca |
| t02_invalidroledate.png | 27998f07da0c462e4f558e669fe6f89dabf04415bc21a6f8192d1d60ec2d4249 |
| t03_missingreordercomment.png | 79ac7294ecd0adbb625c0fc9bb9aa1c1dbfe82c825e0e25e24197122671539d3 |
| t04_unpaidshipment.png | fd6921e620972ce722eed84082170c2c916b2982eba19e7b3646d8a9a88dc929 |
| t05_overlappingsupervision.png | 4b6cf8078a6f1eaa6f76ebf8c52e563df94cdf6e0d5e0a9264caf22a85d3eeef |
| t06_pack_rejoin.png | 92757e151e1d4a3a9f2e434482ebbfd08f3648f4c4e6dcb01aa43572e59d23ba |
| t07_employee_current_address_overlap.png | 100009c3b759676ab3d43373c77d1a15766d22a2605679905276688d26d88e61 |
| t08_customer_primary_phone_overlap.png | 3b4049230ecbb99f4df14ef0774b62f4104894a9926e3425471d60ef59f998db |
| t09_incomplete_wine_composition.png | 123911f6a15ebd0a1bbe77641955ff04a7eefc93d36badd8f898a9e2742bb991 |
| t10_harvest_requires_variety_planting.png | 3538f35bddffcac6d693a5e8bef1daab57dbbf90fd25e83a73acbfd04e3e0778 |
| t11_refund_requires_order_product.png | c848707690666d91733847f820ecff3d35d38202725c952ff30b51d185d17132 |
| task6-e01-1.png | 63fbfb9d20f354f0748616e84af9ed16247d398e66191dbde283ff9f5542d95f |
| task6-e02-1.png | 32da292d22eacf034400f4344c796560ac73a4571739b33a188ade0298dc6fa9 |
| task6-e03-1.png | f12534c72bb7ab4242d62e779ceb2bd9f92d16f2379800fd5e85f581c8a6f5c8 |
| task6-e03-2.png | 4b3f20573883de7e86f925226c25801b235e7e0e22f4b53c9e56c6bef4a8de2e |
| task6-e04-1.png | 883c46766aff8047494197a30221ba49b0dee4c47f5aea5f98526428911944d5 |
| task6-e05-1.png | 7db9fa80f560bb7287d6ec505fcdfad4662a868ca97c4194e578cd160c5a656f |
| task6-e06-1.png | e1dca98469148d7ddc63ecc092c85649fb352fc74ecb52c8fb2c808fb74fb33f |
| task6-e07-1.png | cbf2a6eb0414ed39f2e086394941a5dc79566b75bcb4d155812e85f32d5f7431 |
| task6-e08-1.png | 7afd60f46666dce16af4fb689979691621b559823c7d4582b191751451eac02c |
| task6-e09-1.png | cbd0588f1909c5be4d5aca549c1bdd683560be6d3ebb64bf7ef3a2baf1642dc2 |
| task6-e10-1.png | 2514ce4cf9ffa4bc6b0c70d12ac4ae681cb55de34206bcfee653d63a95b0d95f |
