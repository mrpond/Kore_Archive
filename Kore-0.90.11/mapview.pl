use Tk;
$main=MainWindow ->new();
$main->Button( -text =>"Refresh" ,-command=> [\&windowwrite])->pack();
MainLoop();

sub windowwrite{
#定義ファイルの読み出し
	open (DATA,'<walk.dat');
	$map=<DATA>;$map=~s/[\r\n]//;$x=<DATA>;$y=<DATA>;$map='map/'.$map.'.xbm';
	close(DATA);
#画像サイズの取得
	$maxx=0;$maxy=0;open (DATA,"<$map");
	foreach(<DATA>){
		if ($_=~/^\#define data_width ([0-9]*)/){$maxx=$1;}
		if ($_=~/^\#define data_height ([0-9]*)/){$maxy=$1;}
		if (($maxx >0)&&($maxy >0)){last;}
	}
	close(DATA);
#子ウィンドゥがあるか
	if($my){$my ->destroy;}
#ウィンドゥ作画
	$my = $main->Toplevel;
	$size=$main->geometry;
	$size=~/\+([0-9]*)\+([0-9]*)/;$sizex=$1;$sizey=$2 + 50;
	$size='='.$maxx.'x'.$maxy.'+'.$sizex.'+'.$sizey;
	$my->geometry($size);
	$my->title("Kore - $x $y");

	$can = $my->Canvas( -width =>$maxx,-height =>$maxy,-background =>white )->pack();
	$can->createBitmap(($maxx / 2),($maxy /2),-bitmap => "\@$map");
	$can->createOval(($x-1),($maxy-$y+1),($x+1),($maxy-$y-1),-width=>2 ,-outline=>"red");
##キー入力イベントの作成
	$my->bind('<ButtonPress>', [\&pointchk , Ev('x') , Ev('y')]);
}

#####マップをクリツクすると座標が出る
sub pointchk{
	$clickPointY = $maxy - $_[2];
	$my->title("Kore - $_[1] $clickPointY");
}
