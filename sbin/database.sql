create table strings (id int not null auto_increment, string varchar(767) not null unique, localized varchar(767) character set utf8, localizedFiles varchar(767) not null,unlocalizedFiles varchar(767) not null,primary key(id));
