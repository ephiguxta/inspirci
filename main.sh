#!/usr/bin/bash
# set -x

repo_link='https://github.com/inspircd/inspircd'
link="${repo_link}/releases/latest"
url_effective=''

get_url() {
	# obtém a url que contém arquivos do inspircd
	#
	
	url_effective=$(curl -Ls -o /dev/null -w '%{url_effective}' ${link})

	(( ${#url_effective} != 0 )) && return 0 || return 1
}

get_bin() {
	# depois de obter a url efetiva, monta o link para download
	#

	if get_url; then
		local url_path
		local version
		local filename

		filename='inspircd.tar.gz'

		# faz um grep para pegar apenas os números
		# da versão mais atual
		version=$(grep -Eo "v([0-9]{1,3}.){2}[0-9]{1,3}" <<< "$url_effective")

		url_path="${repo_link}/archive/refs/tags/${version}.tar.gz"

		# realiza o download do código fonte
		if wget -q "$url_path" --show-progress -O "$filename"; then
			return 0
		fi

		return 1
	fi
	
	return 1
}

main() {
	get_bin
}

get_bin
