// const { expectEvent } = require('@openzeppelin/test-helpers');
const { network } = require('hardhat');

const ProofOfStorage = artifacts.require('ProofOfStorage');
const Payments = artifacts.require('Payments');
const UserStorage = artifacts.require('UserStorage');
const TokenMock = artifacts.require('TokenMock');
const NodeNFT = artifacts.require('DeNetNodeNFT');

contract('ProofOfStorage', async function ([_, w1, w2, w3]) {
    function getProofData (data) {
        return {
            _nodeAddress: w1,
            _userAddress: '0x250de5e2817233DB3b2Dfb89b6644f178072aDC9',
            _blockNumber: 27072668,
            _userRootHash: '0x08699cde32638e38ee65fde865b8f72d759350e8357b67cbae2db7e32b7375e4',
            _userRootHashNonce: 1626169061,
            _userSignature: '0x01e522f826b84d9a14f1e63569bf6bf97eccc2a5e1fcae2205590e758f9956df7e63695bc7b4e3fa351a662bd39858ea6a4274de081767e09ea8fd2b31d2babc',
            _file: '0x9f399ef51355df5c9800658bb585e66b35308915bf62bbd37a167f3f0e299b4664309338e126bc3e96a84346f0c3d755897d4d951a68a3a1ae2ba8549a45c7617f324fc8caeb91fdbba43442a43693a7aa2b859cd812f55355fb5ca231564d5b32a925ef33fb46f601816bc3576637cf3925b3b648a7822422f219ed9714ebf7a4f7e9c918ef98a042ed7c3cae0d47d2ed4208459a2b3c32a298d23557f3ab3d9e0ed88b13b73d1bdcef65e0e0af0ad526057c643aa61f62578f21a8647f36396b713c39ca2f34909d8cd85be20e94a8181f9eb69d1553f54b86708f5ddd8688d756c6f9f6b1681b0a7a618f708d7ad42f64aa54a25b1fe6b3607215b24352ea0babf9b4ebdb12186f4bec0f861d17d947a0b661e3687dcf080e28e36d7d6c046c7695395947f68579581e7550018c54a10b882fe9d67c3933a23ab0867d833ff76d09d0875ae1d4c4838b1470a3c8086a0013b80845e056cbcd8623fd39ca92dc799271ca4774c026cd65fea0fa413f97caa98ffdb78cee36231fa591a5f8cf68d8eef148eae78e5c5dfea190f59db7f047bbc7716abb1950caf1d5a18c54215bcb50c31d3efc7eee311ea001ef6551bc79f5e4cf40fecdf032783289d3957c6e3b023e890fdfce5f1965c9e11f9aefdcd891a6a6d29cba137ded5d3cbbfb282e169b8806b2c6ec9267ee440bbb5932036fa86170a81ebcafcdfb2085fb5cdb8d6c6275db36b1d21cfadf879a3cea1b8c3ddc059417c3a73eae64ac60fe50390f4dc2ae861e899e2106e3a2618886b84308442389fdde77cc98aa3da437806594269562251c2691fd9e99be63c3f0709edd3b74b0295ecf3d1322c55418a451e2207e07a9fe4cb10d5243cdaba21a3d91bd94b80155fc5ea14049d41d82d610dd39771cd7e03716c3a513c700cfb2ffcad99e871736de0a9cb2c75af7c46eb8672b1f2f91dc3578c51afe9d355b132056437f6b557ec59558187c65134d357594ddce5ae4b33721d7d885da6e754ac7b81f41332f3c367054715de41872893e855d82e6f5a03fddeb24bad094668c609f808f3ebd2d16dee8dd63bbc8957be9eb7bfbbcc06609317a64f83a815798bdd9b05df5322f509ae231805f09b0eced54adf6b5c34018bba6e1893375f974a1f30f2f0e43788adab0636439878bdbfb8095d5012307770c0f85c2856a359b674abd67b378eab68c8220670c7d964f7c3406502cf9c5ab73bf31e0409aebcfb6710d51a9f6a62ceb75d2878e47a63bd1696bd38d2fc4533584abb19650049c6ae2c5d287c581e15ea156c7d2a811fddbf93adb7ecccbbcfd0aa6bf12a2de48454fd874a712f0e316bad8e124e0af6f4bf61aa1527a69f55d922e73c67af7fa984deeb51d9ca2a059fd7e7e3bc5130587893ef77f7e5998852709993905a97e12cc4eb21dcaa193bffb9409cac1198ad4b1f54a762fe398ceccaffc18a7d74280b252b908562f4114ecb548734d2f32ab38a65c8f49d23bc147a01eaab5586c25165e2914893a5ed25923d2328bdb58b71027670f91569154235aa361ce60a22dd65f77ea60355b643d4c6da0098f0317cbb98a762d3205493232e6b4e784283ce900ea8c919fab84d059f0b176d5ed268dd95e50f26118d24cff0f075cc464bf3eea814426d909e25f1b5eb2553b3aa4c612594f9be46d8f6635b19569c4b046b4d1666331a8144a1956cedbef00aaebeaaa8c4433e1a9a51f8c2e20916d1c55a2254abe5fa9cc1e7436b014ce3ed376d88f325e9cf9049d8db945fc6c925a2f7393efebf0794d339af6f5f96f337f0ca5839465fab8f9e5a88678b9302332cd9a16398f7dfbbc520315a9bca71190927c325654186f979c6adec3dde343306c71cf4bb9d13ed736a8a7b1ff08c083f15821225b576f448d5e2b424bf6bea3da213bbcbeb4e890e97d031aae86b33214fd1c7690d7219d5c9d39df2e82736e829aa15ed75116d9ceb3b8d23d6798163f13f1ea8801f12192beb3a2764dec95e586e2d6f4f074eb2c64157d3f1f5154167b4385dc6cc9e3033501050a24335eddaf7e5fe5d494aa1818670bd94ccbeca7a8b23309e176d9019b5259de28c9c210772d80f2615bc9f78e5ee7218277b8152ed0e4ac8b77de2d8084f7e5e2bf178da1ae59c745e91f4c697734cc1accf807b8ada7fe025f9a609d8b2718f1fef07bdc17a4c90c0c0f36440a4a196d2dc890f7609bff6cc3a33e59fd6e6ced4054f77655dd771075310766a7ba3454a6b04ad8f89cc4c2dbdc11ab5707f97298565254c232418424a2a31a16a23d18a6708433db5e1cd1322c59463cb2d6a5d0f9e0cbee62c451160571ce69ae2977f48b8f8fb8268e3ca402cc84b72ad0309e69a0c9813c0ee588918cf9f4899ae149fb1bcfe7f3dbbe7c9289fbe239e1b5ed9f249159a0c4238e0e8f258b750b351a1e942c16f6138d90da03b99bfbd4ce9c5cad80b37202f99efa0df04b4e1f80529aa48ab824c8ae31c1f49e28a831433612a8523860738ca16ab0bdb20097bbaea2b91df595823d9d8a8f0706bfefc4a5e53790977575692683514f99917af1b8fc4693a93e048c21619d1e60df11822167fed7d98159ed8e9576b6042025a2988e44520e6f74d53a7c83580ab138bb5c1f2583e4f65284b6e791c0484eed3b79089147fe3d5cb6ffdb19870d7ffd7b0c4188600fc3494ed9954e79c1fbac165ba1030415a699303eb1d788cb335be59966daf8b7fd3711395071e76befaa9f843a9dbb3602dcc57e88bc250d9f0a98b077a8f39c4abfe6c05c4936e8b92d5167982b431681843f1016e6d68f9c3b00bca355e9e123cc031e97bd73633dbda9ced1dfd6d79b5bfe3a56062f56c9ccb550a8d42a42a6514e37ee932ed111001f140e545ac7481002434e85c29abd3b53fe03376385a0a81fef8a07ad92b11c4838ae86a5e442a850630f34100837f37fe63832eb3e9a0ca7682194cef1bcbc8be6f37d594339cd6e9319fdde1bb66ac8f45384484c361b96dcdc14143e2d488b6098b7c7f536a467663d9aeebc108491df2bcc642552241f2c86374fec927e7fc9e648670ed3344f4fa11224e2395bd30befbd8dcf51357154a4b2f12ac37773426626ef88a9050e9e681efb8bee9af2cafb55c46b3c5687b139b58478d6db7826c671086ac6e99d238fef71009c9eb708cadfcf4d0942f86d5fdfbcc04012813b9a70b11803a5d02c8c5e6cd910eff9132e5feb152a7ce186c0846e2a654d5bfac96d48dda38b164a3de5187c2cc7940bb5b357ed4174e5c3d96bb59a9d8c44fddb30f6cd9c58e3ff38f344a7d5cadba6f2a6bee6f6eb3b0178a12e4aef314262daedc59346c3e71fc80cdc4ed0b4ba572d192e53fd09a658a2667ccfa0a7038454c928d3803591e9d0721452d51518964d3de8eb0f4c47391a62d6762764cd0d3d8da11e0f315ca21372abeadf9b128394ea0749ef692265be0d998f01db5ddd88110bd7929347239841d51a784470e740512ccb146b7c10b327809f30298d4b34bc7550bc2bda94e043bbc825b135eae23632471453fab37c5debae079e55cdc606b6afb3f68bb171fb8e4a04f29b5197dd121ce1f868268a5a1adcbd69ded9f568b65683b2760cf501ceb95019cf2ffa131409ba5a479ed37ff9c35087cfad2a7b983e42ce7baac04fad37bf8b6dce966de5741d60055ed3247f132037ccc961c226f3c17319bdcdee7d4a7771276821030c5a7117e05b22433d1d8316063a96c9fac25a4a2cb3c60618f9530cba73bb7f31273c99ed7d5138038f3ee399d8855d3659b64adb3adb89052bbd7e08917758195591ce3f2583e2fd4bd9e03a34e0096a2de8f00910a042723ceac8d1a7727cffa0e657b15651ca015e9a4cab889ea91dcc793a288f49a015f79ab1557f78a4a166d6a3d93afbb6ac824197d9a959dc3026936026c60cf49ff990692aee1b4b7a6e72f2d40aa0224d0bd038ea64b150235fabca83f5033e10a1388da4c212c4effa78a7fd20ec19a2de034bbe0fa93f9d6dcfe6e32b1a1cc5f848cc5c210a4c9a73966583d529512c1fb4c6f7f99b41754c4347e51e0a966d3a2e65757130a7c50f25fad6ac8364505b2878bdec7c6d7554cbf9fca095a0ac10a9360bcb17779e8e52cc9fd0cc2807c943b734730fd61a8557ef145cd0861bec98559561d462b6c4f8bba4915c04521c04560645d5f1f321b7ba6fcb11260cd06ce85e0bd129790c60e79988e1b6ee574fcf52c552cef8efb874ceae7ab5b0c266348851bc3348e6cc3734f43299c956568d82a515205dbfe084be04827c7d2830d77bac446ba952cc41332724f934c20a38160f1d170e5ebcd09c365e2027ca1863c0a3dcce6641a94e08833ec23ceae4c990482b797fd412c2661e65a63da5066d1962b6f5ff75273031aeef49cfadc33900077d30709207b994996b0df81c0e515e22c6b5c02cf5863c3af6f814ceedd971abdabae7977b12db2b2c78908e48a9a3632688b27a5571643270487ac417af0eb3cdd0e5bf50c5e4f1665f672d03c5888b9d5bdc27fc1d2715456a5314ea700a3ad76c10e33f756d7762d85a6ba0e21966b389efc7e937fd7550da16f4b67dbda0a3c1e1db844f780257dfb9dc23b6be5ca19511d0c9c1ea561252cef071f1f556a0c7c21505ea66ad2724fc808d425fcf92d58c3756170ed059af1a80622516800dae00f2365e6890b485c2d4c89b7c815229fd07a4c452992e365709b2182d25b12a7c0dc0d9522b692c9970c0566d62b4da4cc4c0f4919728b9051c6ea36a43b15064105f6793572c5a66b7365eee1d8d15e44058b497e6fa86b283623013f6ffd4d89fede2351412decb649d60cef31e64de7ba43ac8f5baba734c24454549b8d95b81d13e003dfe09c7b7651c4bb30cf2e3add28e2afe34cba0bdaadf8f144a344bc6b942986a2f7d2894753f39b4e004332550a56481b427c697c3465c6883c6aa8748f04e05ba9142b83680445e21f56802075df6f4319ea77e911d5a5b67a3c071ea79253962bcd04e6eb90f63cf490ed3c34ffff55a3782d5d02394985db0c513d4ce14966c982fff249b9a850609d4dc5c4e98cb30219dbfea17507b9feaab5cfd78881c4ad32d4839ab494165de42b1819ddd0503ffe4cf037bf358b5df1426c323d989b124cbfa9f8e2efc7c5ee6d5b30c1c0863409fc434e7cdb98886f6dbc6beee0f52fc0a21c95c04aa2aa98e71118d4ae0a5876eff60951652c9d9c9992e7df8f71e18eebcfb1b18e7939bb87639391681d16ee41c89e93d953d51877842b03146c16932419df9be2363a76e3d4d399e820234213f777c677cf98e7ab2f255408549f0ebd006e824caf7251ca7766c0c2101a09eca216fa6af96c6301a5bc09829092f01dfe7dff632de04f7d297749fde113c33f10d54103e71b49b0bf26816ad2681fedb44d4452cbff20a2a76469576493d72a887db3bafc54082535c3aaa30e8050d16529002824d5dd05ea7d984c042c15ac12f1a212450efb7d9fe7803a228debbe2a3596d57b14d7cd2100a33327df6ae01db07ca96843d2fcb032499351bb31cedf135a35e1041350630cdc304aff9a172a96dcee833f4208c83be1559f5bb10f0d8e73125e6cc77955b772b9b302ea2c16663c11523d55a588cf4014be94daf2d16a22a0531a98a684e51b5a1840bef23bf118763ab6934a454cf9a9371d4e1346cddf55941092f22a72e936e7ae326677b61bb258bdba5c4e0942bf720fc47c28fc4e1cac5ecd6a448dec2fb3fa5497174c44fceeaea468a314a656ba42a8775f62521476e65e7e4d3217fc48645e7bbd633d95198ce0fd2691db7e45e4a2e334ef16f3d2692e176fe14ac94f7d8f9c6e982c8fa221c6354d303d531eb24e5f9d4e0f7c8e644000a0f4e99f7576016625e8707f272326bd004c43cf25c584d41a48ba3e3b2a38254be28288f6acf8892d90b5e5e3e9816999a3670f32117b75a8d24c1071d04928e5c00df9668eb0efd455e04b0d38e1e6b946771ada040eca8b8dbd3540d5e472a48f2ce9b60dfa00d0c77467f6e38763b2c657484775281ecce9849ad8fc1a5b2a1eba2eea331781d96c35d3f2e83090ade8108fb4b3141cd7d9dfa0f2e62faca4091cabb0a2a0a73ad78fafcfaaa8d19ad3ed842b23e6d1ca3a3745defded507d592e4f60efacda6c40e506942f168cc9fae9db7886d32016aa4d829de70d0b597ca985831ae78dd14a70ce6ed456e283e710c09c71c6b2f18d2e45d8704e3403fdcd6537b1b2e3284f101db8359deaec0ee22f110335f7d7ab5b65b3cca98ee5f2704f7c5c086e6a55bb9a872559dc5f027cf03c80cb1532ad26ee3f4aea2fc01c9eeefa6962f0db01186d851cb34d1ca4e7ad250d32f611c3d7ee46b352b4f2e08412aceeea7fb8bd182e9820a9070cf0cd12cfa606257b9f5e018dd6119fc02bc7546231b13b576ddc3592781aa1c720247a8045289c638d63918d4cdda39d759be021759877627af792b8ca23a146900fe22729be828225bcd4015fb2bbfef4aa6a56a3d116d090c73303e72dd425a9a6ab39ccdcd249eeec333504964177667f503f475877074803ab7039bccee8436d6097b65dec1132035f968c0d84f8a3df96f13356c62f4601dd7b53f3a654846c13d861fe03f0675ca9639bee1b1642eeabefd3010050983fd6f32e6a52394f8fcaa91816cd3266e622a5aad17ea480d59e7e7eb83419b36deba0faf11a7922760eefbbb8c6635b3c3bc0de21930661e452f9d9b05158234530ba1ea908abb9f35e3adbd70efb808714252e9e0959c837b9d4d36f6b5e6a5cca49bf371ff76ad17676d67dd3b3544ceca3215a81405bacd86c810174ea3c500a0a327fb8d7a3332b5e43636b59d221e4e59f788445a3a15543437f496f2de53e147392d65eff2a9c50a78853ef1ae0d0e1feab73570d6576d635ac43fe094d10e49abf654a1c6f63a80015b162d6eaea2ead7adb2778f4a1e43e362fc00b2d1397d14d1fdb28d378c0b4d2714ae7ee88bb690f28101992503535faf3fa4576d39f119bbaf9e7d9ac6d7ae2a6714fbe89c8d7b372b26fe246b44edeb2cd1f4a2aa70c46999d4599f4feaf16784366f55d9bf81120ecf906072fad9abfac86a411413f7bbb26236ea0c2ee3160de5bc226ccaae53fbabdbb666fd4ad67e4093cf1a69b5dbc3b30f37554d3fb3851e3e2ad6373d64f9ed1ae65ffb3958420db0c00ddaa9cf054a553918702dfe2c7699beba7173a27e500cde55ed997686cee0de73263e62a014f73ac3dfdbe048ff601bfa7da24693d54f59781147f2222956a81bb423f48d7d5a683f63a5c30b1b6bb101910ddb243106f37b04261a6abdc438482c67c4473e015a8d19118f166e7aed5037fc7330983599aa0ac875b73caa99f0929bfa7b6e3627e39b4a2a833ea3dc271d5d4cefd053d9e103f8cadf22a1746ab49df8967eb814c32a122220ce97054fa2e0c1b662b9d9eda1908ccacd48818fd67a860c5ad89a47586ab2a44dfbd33778d71e33d9b7f95c0dd0332675eef5882908cc111e80255f8a04cd5f1796c826051439a1b80585b6e3e1b9f249e1cd6bad8c58ec41273e51e3476867c46147d84187afafe9971771c7c72c9fbfb843708b651ba5005799aaeb57e596896e5de9261d16781b69f54a3edd92da4b2ba5abaa876a85072c8e32f00317ff1df7e37822ea37f9ddf4b5fa12541dd28492ab86ee0e7d99fba47bbf2eed5d54147b44c77619dc3090670f996b7d8066a69ddbeba849d3772dcd987e02b5b371c6d57bbfafc6654136f74d2ff7e2244594fd911e27b18bad4a742eb56cc994aaf715d74ec7fff9b4107342eafa735deedc646519899cea92e7e90594f62cb8b0a8629298bdaa8c325943c0c587668d70d7476c69a3d50bc9f0aaf4de89c6b3687160a791d0f0673aa462441e1e02f71b2f9e07e3401b549612c0df2f6ce400aa528cc3b888b5839bcd2853b0399e757849b10299e0f141544fa51f3085f0b36b15fd576922a73fcd557a23388ee205ca96c84a1f6da01ce9004c8f8e90fdb7d3334b9750baf6fe890b4ce496dadebe50e06f17f4a2036782de11b272c1c19aa15408afa0ab0478023a4d500ddda916b4671773fa3d0628a9862eb4cd5703cd1b6e024a8efbfe11d4791f650833b93a0fdc9d80b4f23c14bcae63a1383bf51aca53cf78dc46b8b450ddeb4a24aee2d53bc06f50b5ddded20625ea81dd407f7cd06b455247419cb731831b10b1d64b20a1503971f693e4a94ebebaf45bd989c994dbb23013d7d17a2f977167a67feba4558b714621333057e9b38a1a13bc5965506765bce91eef7e1286c63e4114547e558d333f143074443532f5e22985317936ca9ee8f1f08c6e829a955d7b04dbdd0ebafd10279058913af03c813f0e7af5e36c86aa0972346f84404c6a95fb4124cbf7d9d7af1d034729d36aa0cc321824899978d400fd842d17daf44aaba305e77cd50cfc0af13099a37502752f58d68699a23efd2d374ec08dc1504b06d0400ef48866f5f4c6bd601831e0465dff39dc2fa98dc41123a1371aef6e9f578d7b6cdb9102a396fd83327b815f6bb91400797c2f43ed9b0009eec839a53ccc5be213dede4d8f32c51eb81037498bed4814cc8e0c55d27f275e776174fd800f59f7a3f597b978ee29cbb99ef92be862638d8137179d0a1327ea458a527e3868d754a757359e95c5cc13250694d79e0d887c12936aff8cd882f09f71efd6c90e7d6197d1d40c69674a137a097e709609d29d7aabe0b5828e94c3df56d1d72192b70f2f889e6c04491a37d0681b6f0e68335cc70fa20476c831f149b544e2e7558192bce342883fb066f7f1386fa6aa28897ff0ec73dd62b39e9d18b9e80cd8fada70b273f123a559f0cb8fdc6d275f8f45f21573f386bcffa2c4c9e247c3d52e3180fef4a3041d867fa91bdb65ed4ecb2a3b330b64d01b90065a51c882933eef10be7ef5e4cdfe7e9e6d63c65a0906bc22224bdcc98369f43518685a8fb20ebe66b34c34b09bd788e766883655539a9f254650b5bc4e75a87cdf7f5e3f9d24449db0f8003c19d5e686ad0cf0025f7a06ecc86ade624b85d307ef32687e586708528ae912d95e817e1d23cf178b27291d70b715001dd849fe6221dfaf99928fa05f9c9fbf23e44ecd76a95f36e83a3e9de7cb9d565c53e7e596f01a762422b20f7047fe4494354fa645c2f3e34a3972675c340dec5ed538f193c123b2b8f1679fa824f63db3206c181ee599eed1987a07ba57a92ae647d3e6c15c1aa182145227f4e400c96508f231a8e38ab23a3b51b32f402c2244ede3e1ff6c98eb31d2a23cbcbbc1049e0e57d9b7c109738320704dfcabd5a60f43ddd20db1ca7751871fb7d969181a8e871d62af329c0b1373e660e535259d31847b14aeed5bed7b1c0c5c76b0b3156acfa16d619fa1ace498e40990a04eed52edd83053620719e3c47888b2bcb6fc9c480116efb06da1464579b4088e3483e16cde4129aa756a4e3dd98c27997ae51509efc9cbcf5c7f3f8902f7d3bde481a0f7dc1597800d7e7cda32abc75e6d99f6b91772d2bede96684f49210f99232f3127c50dd64a8e182b42196d7a87f4d300623c546754b86df626bd0c09412dd37861a46ff999da362e7a3cb00804665f44db196b1dd00cac7129af7dfa47510c91b7fc008e252fa3d4e6aa2b4a67620e5849bae11a188d2875b8842b16862979d6a252b7f909afc3cd3c6ef4226d74e8f6e358e2c8ec488557ea43f7520559d3928431bf6b0f8cd2ababffde10edaa42ebb97a7c468d917ceb06d75e43de3b36cf920367c3b886fdaf105240f27f38dab8c44c5a55a9a943bbca9ddd773bc35e209ff0200ad6f8d72f76890eeb75d11e716db0aa9d86562ffc639ccbacd5328100797605a837a3aff54699af6c6271f417a645a9766b82cb6cb31dc37a924e31631d23a1369bdc06bc8fb631ce221fa7a69a8eea0654045c00be2a3cf48536e7838a3bb59572d6118857fc908e8fb01c7b888458fd96b6a7d13eab8e892514edfb753c7d193021564e14eada9a20a6196c811d3b15c3f3acd10e4b075981bd530c821d7a771688c396ec009670f4967b2c3b843f127216db7f73b7a8326d151dde4f109da2f5305965acc2531c89d249211fd655d41157aebd18d5295d889237bd5bedbde1207d28d935ab124898787bb33c9866898cecb083c180c425721863b7d167b6fa57e8cc6bae874b6ebe17afeb2e4145a50a7391a7db101c62af5341b64039007671fc49e3d3f0b72097fef9d8320b4d531cc998c2a28e7c2a98202aa0b0cb8b24ac34c0a9665e3c02be3f736cafd63d25f8972eaa8a560dd5b2dddd87d319b797fbb41ca9a3ada73287a2ebb2bac8668daf27b60cb0b19bd8a900c37c27dc1c91637e2299045c60ea65b3dfa6e274d29dc555c524ec63d08cdce079ec402dbc8321f9952b9e39bc2db1f2a11a3930610f24e7d404da7d80abe44c6ea3e7798f5287bc55ce854c4f5ccb37f467c9ff829a31ce060e4d19fa359b888cc4441a653b184568438153110888caf7f90e6243dab9ed048924ef2df1cdfd1782d9147cba69a90564eb69ddc8e8b98a739134a337cbc7838a2c3d4b5d8c83dc79ecc234dbbd89253a300a30751048674829cbbadbc67c64cbe35cfec15b8d2e13441c4487a4d9fbfc71ccaa377cc018c0830b31f65ad9742909bca63c92d0a40b488ca3efdd26c3252cfcb0667ee716a004e75356e790688a1927318bc4a9d97b3e7752bd895c9685759c55b143d0e875586000f8dff0981ea5db9e60fbd873c399928daf3e2896deb696e337e834b16617d548c56d7968a1448c63c6c09ab326c67432e619939ac9ea09b0f7aba925747d0c80d4468eed660905c277255b428b5776834ee2340093d917e3d304f9992290ce36fc20fc9bbf9e3abe8cb1c7283fdf8ea821df8103db52de6cff08a56b0de6d0bdc5316451f06beb1725ffb7d852da25df33026a109ed7916f59b3e32155c17cbf527e9217be96534dc3e1abcda6a3308b0aaa3f457beb1e80e74200e1eb6cd886b537a9d13e7e54da08754a3f1ae018acf6741f994e6d35032c864306c56ba8d0fdcf0ab2e6943e6f61eda5955d9c4b7d14a1a2d45ef5fab5cb25de189c6147ab603665cb0fbe34515efd0a46ce4b226e79b5e8c354bc2a0af533e449bf6f5a14416ac53eb1d4a00024be0a96b3289cf0db355a7ae1a7a1a3de7cc87d3367049a3bf69883d1e54fbb98f2fd5480b81b1ad0d98e945ba950bc7ca2dbf86e59c90e9d194df3e53d8f2f177f9825ae8337a9b15a06102d4ffc4a3fe6ceb4919ce39b43e00bed6d1c2c55dbab28cabd70e0007555fc4d28dba7c790eae557356adcf19465ae6da84d251d2f18967987180905818dffccd78d63db3e408800e9480adf91a8cc0836309095b60c8c58c430163e90d727644046fe090eec9a263e59cec537d515ef78018191bd3a5287b1d4b4994a1fea55b633fc0fc38785c9174a3b25bfdf48e517c601107cc09f8521f235b6b177e20c0cb937f6d6f7e6c163a8771fa177',
            merkleProof: [
                '0x4399be015dde9f33c9af817152f065953676d08974f89b62d0aa22eb77cf228a',
                '0xbefe2461f47ffe43ab336eff5fcdbe78ed0ad8a16b27ea99a05c9bbf9451ad52',
                '0x0cb31315448a04dddddb327df54b5a3c33340cc0a38677366cd93ea50406edd0',
                '0x1bf624f135b37fdfd958b250331a79b0f0c0d7fb563f8167aba8f72f18f30eb5',
                '0xb10277e684f8c35ac3c690c07e5542a24ed130eadd2bcb8802044a7907d6cadf',
                '0xf1d64f3e40d1f4663029616d008e60993f837dfee54e9c0c669352194361e3d2',
                '0x6bea5a794f67b499bd8656a46d3d3a221fd9b51b49a70cc8a3326fbe35a09dcb',
                '0x82ae339ac7be9c627ab4d9d58386e7fad95665f64b81c04a81c80a462e743ace',
                '0x0c7a62236c3670c69bb270fde9f21ebbae10307eb3c6b6c4b84963d18177379e',
                '0x3fa4609dd77da140a83c6104fce72aec83795991d30f8996f45e22439005f91c',
                '0x95b289828fb3ceaedfa051f0b790e39ce059293309ae1d550920d2041ea3b980',
                '0x637af7ec0b60eb8bb1a3f48cecd2e8f230130b24d657bba5ee8ccdb036e666cc',
                '0x6b00419a2cc9719a273015d18eddf919fa5a090bdba0f0efb2ead9ede3491229',
                '0x04349f4128ad717b93c1caed4b599b5f874faacaaae3a94b3f4f8c711b08a37d',
                '0x131ced24478a0609f470795ce1bb49495a704f3910b21c111665435fe24eecd0',
                '0x0000000000000000000000000000000000000000000000000000000000000000',
                '0x08699cde32638e38ee65fde865b8f72d759350e8357b67cbae2db7e32b7375e4',
            ],
        };
    }
    
    async function getBalance (self, address, callback) {
        const result = await self.payments.balanceOf(address);
        callback(result.toString());
    }
    beforeEach(async function () {
        this.token = await TokenMock.new('Token', 'TKN');
        this.pos = await ProofOfStorage.new('0x0000000000000000000000000000000000000000', '0x0000000000000000000000000000000000000000', '10000000');
        this.userStorage = await UserStorage.new('DeNet UserStorage', this.pos.address);
        this.payments = await Payments.new(this.pos.address, this.pos.address, 'Terabyte Years', 'TB/Year', 1);
        this.nodeNFT = await NodeNFT.new('DeNet Storage Node', 'DEN', this.pos.address, 10);
    
        await this.payments.changeTokenAddress(this.token.address);
        await this.pos.changeSystemAddresses(this.userStorage.address, this.payments.address);
        await this.pos.setNodeNFTAddress(this.nodeNFT.address);
        
        await this.token.mint(w1, 100000000);
        await this.token.mint(w2, 1000);

        await this.nodeNFT.createNode([192, 168, 1, 1], 8080, { from: w1 });
    });

    it('should deposit successfully', async function () {
        await this.token.approve(this.payments.address, '1000', { from: w1 });
        await this.pos.makeDeposit(this.token.address, 1000, { from: w1 });
        await getBalance(this, w1, (res) => { console.log('Balance ' + res); });
        // expectEvent(result, 'Transfer', { from: w1, to: this.payments.address, value: '1000'});
    });

    it('should withdraw successfully', async function () {
        await this.token.approve(this.payments.address, '1000', { from: w1 });
        await this.pos.makeDeposit(this.token.address, 1000, { from: w1 });
        // expectEvent(result1, 'Transfer', { from: w1, to: this.payments.address, value: '1000'});

        await this.pos.closeDeposit(this.token.address, { from: w1 });
        await getBalance(this, w1, (res) => { console.log('Balance ' + res); });
        // expectEvent(result2, 'Transfer', { from: this.payments.address, to: w1, value: '1000'});
    });
    function getRandomInt (max) {
        return Math.floor(Math.random() * max);
    }
    async function updatePayerBalance (self, userAddress) {
        const amount = (getRandomInt(30) + 5) * 100000000;
        console.log('added', amount.toString() + ' to payer');
        await self.token.mint(w1, amount);
        await self.token.approve(self.payments.address, amount, { from: w1 });
        await self.pos.makeDeposit(self.token.address, amount, { from: w1 });
        const resultBalance = await self.payments.balanceOf(w1);
        console.log('Transfering ' + resultBalance.toString() + ' TB');
        await self.pos.admin_set_user_data(w1, userAddress, self.token.address, resultBalance);
    }
    
    async function showBalances (self, _tmp, _type) {
        await getBalance(self, _tmp._userAddress, (res) => {
            console.log('[' + _type + '] User Balance Of TB', res);
        });
        await getBalance(self, _tmp._nodeAddress, (res) => {
            console.log('[' + _type + '] Node Balance Of TB', res);
        });
    }

    it('should send proof from successfully', async function () {
        const _tmpProofData = getProofData();
        // suppose the current block has a timestamp of 24H
        await network.provider.send('evm_increaseTime', [60 * 60 * 24]);
        // mining at 1000 days
        for (let i = 0; i < 10000; i++) { await network.provider.send('evm_mine'); } // this one will have 02:00 PM as its timestamp

        // set dificulty to one
        await this.pos.updateBaseDifficulty(1);
        
        // generate 25 proofs
        for (let nextBlock = 0; nextBlock < 10; nextBlock++) {
            await showBalances(this, _tmpProofData, 'Before Payin');
            const currentBlockNumber = await this.pos.getBlockNumber();
            await updatePayerBalance(this, _tmpProofData._userAddress);
            await showBalances(this, _tmpProofData, 'After Payin');
            
            const PROOF_B_NUMBER = parseInt(currentBlockNumber.toString()) - 60;

            await this.pos.sendProofFrom(
                _tmpProofData._nodeAddress,
                _tmpProofData._userAddress,
                PROOF_B_NUMBER,
                _tmpProofData._userRootHash,
                _tmpProofData._userRootHashNonce,
                _tmpProofData._userSignature,
                _tmpProofData._file,
                _tmpProofData.merkleProof,
                { from: w1 });
            await showBalances(this, _tmpProofData, 'After SendProof');
            // mine 100 blocks
            for (let i = 0; i < 100; i++) { await network.provider.send('evm_mine'); } // this one will have 02:00 PM as its timestamp
        }
    });
});
