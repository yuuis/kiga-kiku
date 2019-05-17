require_relative '../../config/boot'

class ShopSeed
  def call
    ShopRepository.new.create(
      id: 'J001051208',
      genre_code: 'G001',
      sub_genre_code: 'G002',
      small_area_code: 'X005',
      large_area_code: 'Z011',
      service_area_code: 'SA11',
      budget_code: 'B001',
      name: '九州魂 京王八王子店',
      mobile_access: 'JR八王子駅北口徒歩3分 飲み放題ﾄﾞﾘﾝｸ充実!(^^)!',
      address: '東京都八王子市明神町４丁目７－３　内藤落合ビル 2F',
      lng: '139.3419974459',
      lat: '35.6578627253',
      cource: 'あり',
      show: 'なし',
      non_smoking: '禁煙席なし',
      horigotatsu: 'あり',
      open: '月～木、日、祝日: 16:00～翌1:00金、土、祝前日: 16:00～翌3:00',
      card: '利用可',
      tatami: 'あり',
      charter: '貸切可',
      wifi: 'あり',
      shop_detail_memo: '2階に佇む元祖和風個室居酒屋。落ち着いた『懐かしい和の雰囲気』と『和風創作料理』をご堪能下さい。',
      band: '不可',
      karaoke: 'なし',
      midnight: '営業している',
      urls: 'https://www.hotpepper.jp/strJ001051208/?vos=nhppalsa000016',
      english: 'あり',
      lunch: 'なし',
      close: '年中無休。八王子の居酒屋で宴会♪歓送迎会などご予約承ります。★10名様以上でお昼からのご宴会もご相談ください。',
      budget_memo: 'チャージ料390円（税抜） ',
      tv: 'なし',
      private_room: 'あり ：個室14室',
      barrier_free: 'なし',
      child: 'お子様連れ歓迎',
      capacity: '65',
      pet: '不可',
      free_food: 'なし',
      free_drink: 'あり',
      station_name: '京王八王子'
    )
  end
end
